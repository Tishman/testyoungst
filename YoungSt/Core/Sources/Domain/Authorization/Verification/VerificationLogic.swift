//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import ComposableArchitecture
import Resources
import NetworkService

let verificationReducer = Reducer<VerificationState, VerificationAction, VerificationEnviroment>.combine(
    codeEnterReducer.pullback(state: \.codeEnter, action: /VerificationAction.codeEnter, environment: { _ in }),
    Reducer({ state, action, env in
        switch action {
        case .viewDidAppear:
            state.codeEnter.codeItems[0].forceFocused = true
            
        case .codeEnter:
            break
            
        case .routingHandled:
            state.routing = nil
            
        case .sendCodeButtonTapped:
            guard state.codeEnter.text.count == state.codeEnter.codeCount else {
                state.alert = .init(title: .init("Fill full code please"), message: nil, dismissButton: .cancel(TextState(Localizable.ok)))
                break
            }
            state.isLoading = true
            let requestData = Authorization_ResetPasswordCheckRequest.with({
                $0.code = state.codeEnter.text
                $0.email = state.email
            })
            
            return env.authorizationService.checkResetPassword(request: requestData)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(VerificationAction.didRecieveVerificationResult)
            
        case let .didRecieveVerificationResult(.success(isVerified)):
            state.isLoading = false
            state.routing = .changePassword(email: state.email, code: state.codeEnter.text)
            
        case let .didRecieveVerificationResult(.failure(error)):
            state.isLoading = false
            state.alert = .init(title: TextState(error.localizedDescription),
                                message: nil,
                                dismissButton: .cancel(TextState(Localizable.ok)))
            
        case .alertOkButtonTapped:
            state.alert = nil
        }
        return .none
    }))
