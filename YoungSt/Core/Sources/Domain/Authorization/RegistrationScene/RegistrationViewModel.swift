//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources
import Utilities

struct RegistrationState: Equatable {
    var email: String
    var nickname: String
    var password: String
}

extension RegistrationState {
    init() {
        self.email = ""
        self.nickname = ""
        self.password = ""
    }
}

enum RegistrationAction: Equatable {
    case didEmailChanged(String)
    case didNicknameChange(String)
    case didPasswordChanged(String)
    case registrationButtonTapped
    case didRecieveRegistartionResult(Result<Authorization_RegistrationResponse, EquatableError>)
}

struct RegistrationEnviroment {
    let client: Authorization_AuthorizationClient
}

let reducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnviroment> { state, action, enviroment in
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
        guard !state.email.isEmpty, !state.password.isEmpty, !state.nickname.isEmpty else { return .none }
        let requestData = Authorization_RegistrationRequest.with {
            $0.email = state.email
            $0.nickname = state.email
            $0.password = state.password
        }
        
        let registration = enviroment.client.register(requestData)
        
        return registration
            .response
            .publisher
            .receive(on: DispatchQueue.main)
            .mapError(EquatableError.init)
            .catchToEffect()
            .map({ RegistrationAction.didRecieveRegistartionResult($0) })
    }
    return .none
}
