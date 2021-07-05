//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources
import Utilities

let confrimEmailReducer = Reducer<ConfrimEmailState, ConfrimEmailAction, ConfrimEmailEnviroment>.combine(
    codeEnterReducer.pullback(state: \.codeEnter, action: /ConfrimEmailAction.codeEnter, environment: {_ in }),
    Reducer { state, action, enviroment in
        switch action {
        case .viewAppeared:
            state.codeEnter.codeItems[0].forceFocused = true
            
        case let .failedValidation(value):
            state.alert = .init(title: TextState(value),
                                message: nil,
                                dismissButton: .cancel(TextState(Localizable.ok)))
            
        case let .handleConfrimation(.success(value)):
            state.isCodeVerified = value
            guard let service = enviroment.authorizationService else {
                state.isLoading = false
                break
            }
            guard value else {
                state.isLoading = false
                state.alert = .init(title: TextState(Localizable.incorrectCode),
                                    message: nil,
                                    dismissButton: .cancel(TextState(Localizable.ok)))
                break
            }
            
            let loginRequestData = Authorization_LoginRequest.with {
                $0.email = state.email
                $0.password = state.passsword
            }
            
            return service.login(request: loginRequestData)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(ConfrimEmailAction.handleLogin)
            
        case .handleLogin(.success):
            state.isLoading = false
            
        case let .handleLogin(.failure(error)):
            state.isLoading = false
            state.alert = .init(title: TextState(error.localizedDescription),
                                message: nil,
                                dismissButton: .cancel(TextState(Localizable.ok)))
            
        case let .handleConfrimation(.failure(error)):
            state.isLoading = false
            state.alert = .init(title: TextState(error.description),
                                message: nil,
                                dismissButton: .cancel(TextState(Localizable.ok)))
            
        case .didConfrimTriggered:
            guard let service = enviroment.authorizationService else { return .none }
            guard !state.codeEnter.text.isEmpty else { return .init(value: .failedValidation(Localizable.fillAllFields)) }
            state.isLoading = true
            let confirmRequestData = Authorization_ConfirmCodeRequest.with {
                $0.code = state.codeEnter.text
                $0.userID = state.userId.uuidString
            }
            
            return service.confirmCode(request: confirmRequestData)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(ConfrimEmailAction.handleConfrimation)
            
        case .alertClosedTriggered:
            state.alert = nil
            if state.isCodeVerified {
                state.isClosed = true
            }
            
        case .codeEnter:
            break
        }
        return .none
    }
    .analytics()
)
