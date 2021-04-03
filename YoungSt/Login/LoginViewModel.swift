//
//  LoginViewModel.swift
//  YoungSt
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Utilities
import Resources

struct LoginState: Equatable {
    internal init() {
        self.email = ""
        self.password = ""
        self.emailPlaceholder = Localizable.emailPlaceholder
        self.passwordPlaceholder = Localizable.passwordPlaceholder
    }
    
    var email: String
    var password: String
    let emailPlaceholder: String
    let passwordPlaceholder: String
}

enum LoginAction: Equatable {
    case didEmailChanged(String)
    case didPasswordChanged(String)
    case logInButtonTapped
    case successLogIn
}

struct LoginEnviroment {
    let client: Authorization_AuthorizationClient?
}

let loginReducer = Reducer<LoginState, LoginAction, LoginEnviroment> { state, action, enviroment in
    switch action {
    case let .didEmailChanged(value):
        state.email = value
        
    case let .didPasswordChanged(value):
        state.password = value
        
    case .logInButtonTapped:
        guard let client = enviroment.client else { return .none }
        let requestData = Authorization_LoginRequest.with {
            $0.email = state.email
            $0.password = state.password
        }
        
        let login = client.login(requestData)
        
        return login
            .response
            .publisher
            .receive(on: DispatchQueue.main)
            .mapError(EquatableError.init)
            .catchToEffect()
            .map({ _ in LoginAction.successLogIn })
        
    case .successLogIn:
        return .none
    }
    return .none
}
