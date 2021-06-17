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
import Resources
let registrationReducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnviroment> { state, action, enviroment in
	switch action {
    case let .emailInputFocusChanged(isFocused):
        state.emailFieldForceFocused = isFocused
        
    case let .userNameInputFocusChanged(isFocused):
        state.usernameFieldForceFocused = isFocused
        
    case let .passwordInputFocusChanged(isFocused):
        state.passwordFieldForceFocused = isFocused
        
    case let .confirmPasswordInputFocusChanged(isFocused):
        state.confirmPasswordFieldForceFocused = isFocused
    
	case .showPasswordButtonTapped:
		state.isPasswordShowed.toggle()
		
    case .showConfrimPasswordButtonTapped:
		state.isConfrimPasswordShowed.toggle()
		
	case let .didEmailChanged(value):
		state.email = value
		
	case let .didNicknameChange(value):
		state.nickname = value
		
	case let .didPasswordChanged(value):
		state.password = value
		
	case let .didConfrimPasswordChanged(value):
		state.confrimPassword = value
		
	case let .didRecieveRegistartionResult(.success(value)):
		state.routing = .confrimEmail
		
	case let .didRecieveRegistartionResult(.failure(value)):
		state.alert = .init(title: TextState(value.localizedDescription))
		
	case let .failedValidtion(value):
		state.alert = .init(title: TextState(value))
		
	case .alertClosed:
		state.alert = nil
		
	case .registrationButtonTapped:
		guard !state.email.isEmpty && !state.password.isEmpty && !state.nickname.isEmpty else {
			return .init(value: .failedValidtion(Localizable.fillAllFields))
		}
		guard state.confrimPassword == state.password else { return .init(value: .failedValidtion(Localizable.passwordConfrimation)) }
		
		let requestData = Authorization_RegistrationRequest.with {
			$0.email = state.email
			$0.login = state.nickname
			$0.password = state.password
		}
		
		return enviroment.authorizationService.register(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(RegistrationAction.didRecieveRegistartionResult)
		
	case .routingHandled:
		state.routing = nil
	}
	
	return .none
}
