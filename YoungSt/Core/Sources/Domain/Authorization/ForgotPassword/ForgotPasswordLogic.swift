//
//  File.swift
//  
//
//  Created by Роман Тищенко on 02.05.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources
import Utilities

let forgotPasswordReducer = Reducer<ForgotPasswordState, ForgotPasswordAction, ForgotPasswordEnviroment> { state, action, enviroment in
	switch action {
    case let .emailInputFocusChanged(isFocused):
        state.emailFieldForceFocused = isFocused
    
	case let .didEmailEditing(value):
		state.email.value = value
		state.email.status = .default
		
	case .handleInitResetPassword(.success):
        state.isLoading = false
        state.routing = .verification(email: state.email.value)
        
	case let .handleInitResetPassword(.failure(error)):
        state.isLoading = false
		state.alert = .init(title: TextState(Localizable.incorrectDataTitle),
							message: TextState(error.localizedDescription),
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case .alertOkButtonTapped:
		state.alert = nil
		
	case .didSendCodeButtonTapped:
		guard ForgotPasswordLogic.validateEmail(email: &state.email) else { break }
        state.isLoading = true
		let requestData = Authorization_InitResetPasswordRequest.with {
			$0.email = state.email.value
		}
		
		return enviroment.authorizationService.initResetPassword(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ForgotPasswordAction.handleInitResetPassword)
        
    case .routingHandled:
        state.routing = nil
	}
	return .none
}

struct ForgotPasswordLogic {
	static func isFieldNotEmpty(field: inout StatusField<String>) -> Bool {
		guard !field.value.isEmpty else {
			field.status = .error(Localizable.requiredField)
			return false
		}
		field.status = .success(Localizable.allCorrect)
		return true
	}
	
	static func validateEmail(email: inout StatusField<String>) -> Bool {
		guard EmailValidator.isValidEmail(email: email.value) else {
			email.status = .error(Localizable.incorrectEmail)
			return false
		}
		email.status = .success(Localizable.allCorrect)
		return true
	}
}
