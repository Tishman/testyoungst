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
