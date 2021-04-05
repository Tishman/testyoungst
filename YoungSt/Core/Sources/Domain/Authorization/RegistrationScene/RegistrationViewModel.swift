//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Utilities

struct RegistrationState: Equatable {
    var email: String
    var nickname: String
    var password: String
    let placeholder: String
}

extension RegistrationState {
    init() {
        self.email = ""
        self.nickname = ""
        self.password = ""
        self.placeholder = "E-mail"
    }
}

enum RegistrationAction: Equatable {
    case didEmailChanged(String)
    case didNicknameChange(String)
    case didPasswordChanged(String)
    case registrationButtonTapped
    case didRecieveRegistartionResult(Result<UUID, RegistrationError>)
}

struct RegistrationEnviroment {
    let authorizationService: AuthorizationService?
}

let registrationReducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnviroment> { state, action, enviroment in
    switch action {
    case let .didEmailChanged(value):
        state.email = value
        
    case let .didNicknameChange(value):
        state.nickname = value
        
    case let .didPasswordChanged(value):
        state.password = value
        
    case let .didRecieveRegistartionResult(result):
        switch result {
        case let .success(response):
            return .none
        case let .failure(error):
            return .none
        }
        
    case .registrationButtonTapped:
        guard let authorizationService = enviroment.authorizationService, !state.email.isEmpty, !state.password.isEmpty, !state.nickname.isEmpty else { return .none }
        
        let requestData = Authorization_RegistrationRequest.with {
            $0.email = state.email
            $0.nickname = state.email
            $0.password = state.password
        }
        
        return authorizationService.register(request: requestData)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map({ RegistrationAction.didRecieveRegistartionResult($0) })
    }
    return .none
}
