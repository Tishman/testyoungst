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

let loginReducer = Reducer<LoginState, LoginAction, LoginEnviroment> { state, action, enviroment in
    switch action {
    case let .emailChanged(value):
        state.email = value
        
    case let .passwordChanged(value):
        state.password = value
        
    case .loginTapped:
		guard !state.email.isEmpty && !state.password.isEmpty else {
            return .init(value: .failedValidtion(Localizable.fillAllFields))
        }
        state.isLoading = true
        let requestData = Authorization_LoginRequest.with {
            $0.email = state.email
            $0.password = state.password
        }
        
        return enviroment.service.login(request: requestData)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(LoginAction.handleLogin)
        
    case let .handleLogin(result):
		switch result {
		case let .success(response):
            // Should be handled by main application
            break
			
		case let .failure(error):
            state.isLoading = false
            state.alertState = .init(title: TextState(error.localizedDescription))
		}
		
	case let .failedValidtion(value):
        state.alertState = .init(title: TextState(value))
		
	case .alertClosed:
        state.alertState = nil
        
    case .forgotPasswordTapped:
        break
        
    case .showPasswordButtonTapped:
        state.showPassword.toggle()
	}
    return .none
}
