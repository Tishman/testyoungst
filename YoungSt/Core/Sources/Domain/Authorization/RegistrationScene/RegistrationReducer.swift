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
    case .emailReturnKeyTriggered:
        state.usernameFieldForceFocused = true
        
    case .usernameReturnKeyTriggered:
        state.passwordFieldForceFocused = true
        
    case .passwordReturnKeyTriggered:
        state.confirmPasswordFieldForceFocused = true
        
    case .confirmPasswordReturnKeyTriggered:
        break
    
    case let .emailInputFocusChanged(isFocused):
        state.emailFieldForceFocused = isFocused
        
    case let .userNameInputFocusChanged(isFocused):
        state.usernameFieldForceFocused = isFocused
        
    case let .passwordInputFocusChanged(isFocused):
        state.passwordFieldForceFocused = isFocused
        
    case let .confirmPasswordInputFocusChanged(isFocused):
        state.confirmPasswordFieldForceFocused = isFocused
    
	case .showPasswordTriggered:
		state.isPasswordSecure.toggle()
		
    case .showConfrimPasswordTriggered:
		state.isConfirmSecure.toggle()
		
	case let .didEmailChanged(value):
		state.email = value
		
	case let .didNicknameChange(value):
		state.nickname = value
		
	case let .didPasswordChanged(value):
		state.password = value
		
	case let .didConfrimPasswordChanged(value):
		state.confrimPassword = value
		
	case let .didRecieveRegistartionResult(.success(value)):
        state.isLoading = false
        state.routing = .confrimEmail(userId: value, email: state.email, password: state.password)
		
	case let .didRecieveRegistartionResult(.failure(value)):
        state.isLoading = false
		state.alert = .init(title: TextState(value.localizedDescription))
		
	case let .failedValidtion(value):
		state.alert = .init(title: TextState(value))
		
	case .alertClosedTriggered:
		state.alert = nil
		
	case .registrationTriggered:
		guard !state.email.isEmpty && !state.password.isEmpty && !state.nickname.isEmpty else {
			return .init(value: .failedValidtion(Localizable.fillAllFields))
		}
		guard state.confrimPassword == state.password else { return .init(value: .failedValidtion(Localizable.passwordConfrimation)) }
        state.isLoading = true
		
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
.analytics()
