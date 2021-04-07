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

struct LoginState: Equatable {
    var email: String = ""
    var password: String = ""
    var resetPasswordOpened = false
    var loginError: String?
    var showPassword: Bool = false
}

enum LoginAction: Equatable {
    case emailChanged(String)
    case passwordChanged(String)
    case loginTapped
    case forgotPasswordTapped
    case registerButtonTapped
    case showPasswordButtonTapped
    case handleLogin(Result<Authorization_LoginResponse, LoginError>)
}

struct LoginEnviroment {
    let service: AuthorizationService
}

let loginReducer = Reducer<LoginState, LoginAction, LoginEnviroment> { state, action, enviroment in
    switch action {
    case let .emailChanged(value):
        state.email = value
        
    case let .passwordChanged(value):
        state.password = value
        
    case .loginTapped:
        let requestData = Authorization_LoginRequest.with {
            $0.email = state.email
            $0.password = state.password
        }
        
        return enviroment.service.login(request: requestData)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(LoginAction.handleLogin)
        
    case let .handleLogin(result):
        break
        
    case .forgotPasswordTapped:
        break
        
    case .registerButtonTapped:
        break
        
    case .showPasswordButtonTapped:
        state.showPassword.toggle()
    }
    return .none
}
