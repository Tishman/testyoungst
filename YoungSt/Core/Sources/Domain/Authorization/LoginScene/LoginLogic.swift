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
    case let .loginInputFocusChanged(isFocused):
        state.loginFieldForceFocused = isFocused
        
    case let .passwordInputFocusChanged(isFocused):
        state.passwordFieldForceFocused = isFocused
    
	case let .emailChanged(value):
        state.email.status = .default
        state.email.value = value
		
	case let .passwordChanged(value):
        state.password.status = .default
        state.password.value = value
		
	case .loginTapped:
        guard !state.email.value.isEmpty else {
            state.email.status = .error(Localizable.requiredField)
            return .none
		}
        guard !state.password.value.isEmpty else {
            state.password.status = .error(Localizable.requiredField)
            return .none
        }
		state.isLoading = true
		let requestData = Authorization_LoginRequest.with {
            $0.email = state.email.value
            $0.password = state.password.value
		}
		
		return enviroment.service.login(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(LoginAction.handleLogin)
		
	case .handleLogin(.success):
		break
		
	case let .handleLogin(.failure(.errVerificationNotConfirmedRegID(uuid))):
		state.isLoading = false
        state.routing = .confirmEmail(userId: uuid, email: state.email.value, password: state.password.value)
		
	case let .handleLogin(.failure(error)):
		state.isLoading = false
		state.alertState = .init(title: TextState(error.localizedDescription))
		
	case .alertClosed:
		state.alertState = nil
		
	case .forgotPasswordTapped:
        state.routing = .forgotPassword(state.email.value)
		
	case .showPasswordButtonTapped:
		state.isSecure.toggle()
		
	case .routingHandled:
		state.routing = nil
	}
	return .none
}
