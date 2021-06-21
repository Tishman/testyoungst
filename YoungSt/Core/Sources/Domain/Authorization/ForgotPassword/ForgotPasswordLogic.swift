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
        
    case let .codeInputFocusChanged(isFocused):
        state.emailFieldForceFocused = isFocused
        
    case let .passwordInputFocusChanged(isFocused):
        state.passwordFieldForceFocused = isFocused
        
    case let .confirmPasswordInputFocusChanged(isFocused):
        state.confirmPasswordFieldForceFocused = isFocused
    
	case let .didEmailEditing(value):
		state.email.value = value
		state.email.status = .default
		
	case let .didCodeEditing(value):
		state.code.value = value
		state.code.status = .default
		
	case let .didPasswordEditing(value):
		state.password.value = value
		state.password.status = .default
		
	case let .didConrimPasswordEditing(value):
		state.confrimPassword.value = value
		state.confrimPassword.status = .default
		
	case .passwordButtonTapped:
		state.isPasswordSecure.toggle()
		
	case .confrimPasswordButtonTapped:
		state.isConfirmSecure.toggle()
		
	case .didChangePasswordButtonTapped:
		guard ForgotPasswordLogic.isFieldNotEmpty(field: &state.email) &&
				ForgotPasswordLogic.isFieldNotEmpty(field: &state.code) &&
				ForgotPasswordLogic.isFieldNotEmpty(field: &state.password) &&
				ForgotPasswordLogic.isFieldNotEmpty(field: &state.confrimPassword) &&
				ForgotPasswordLogic.validateEmail(email: &state.email) &&
				ForgotPasswordLogic.validateCode(code: &state.code) &&
				ForgotPasswordLogic.validatePasswordConfrimation(password: state.password, confrim: &state.confrimPassword) else { break }
		
		let dataRequest = Authorization_ResetPasswordRequest.with {
			$0.code = state.code.value
			$0.email = state.email.value
			$0.newPassword = state.password.value
		}
		
		return enviroment.authorizationService.resetPassword(request: dataRequest)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ForgotPasswordAction.handleResetPassword)
		
	case .handleInitResetPassword(.success):
		state.isResetPasswordInit = true
		
	case let .handleInitResetPassword(.failure(error)):
		state.alert = .init(title: TextState(Localizable.incorrectDataTitle),
							message: TextState(error.localizedDescription),
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case .handleResetPassword(.success):
		state.isPasswordChanged = true
		state.isClosed = true
		
	case let .handleResetPassword(.failure(error)):
		state.alert = .init(title: TextState(Localizable.incorrectDataTitle),
							message: TextState(error.localizedDescription),
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case .alertOkButtonTapped:
		state.alert = nil
		
	case .didSendCodeButtonTapped:
		guard ForgotPasswordLogic.validateEmail(email: &state.email) else { break }
		state.email.status = .success(Localizable.allCorrect)
		let requestData = Authorization_InitResetPasswordRequest.with {
			$0.email = state.email.value
		}
		
		return enviroment.authorizationService.initResetPassword(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ForgotPasswordAction.handleInitResetPassword)
	}
	return .none
}

struct ForgotPasswordLogic {
	static func isFieldNotEmpty(field: inout ForgotPasswordState.Field<String>) -> Bool {
		guard !field.value.isEmpty else {
			field.status = .error(Localizable.requiredField)
			return false
		}
		field.status = .success(Localizable.allCorrect)
		return true
	}
	
	static func validateCode(code: inout ForgotPasswordState.Field<String>) -> Bool {
		guard code.value.count == 6 else {
			code.status = .error(Localizable.incorrectCode)
			return false
		}
		code.status = .success(Localizable.allCorrect)
		return true
	}
	
	static func validatePasswordConfrimation(password: ForgotPasswordState.Field<String>,
											 confrim: inout ForgotPasswordState.Field<String>) -> Bool {
		guard password.value == confrim.value else {
			confrim.status = .error(Localizable.passwordMismatch)
			return false
		}
		confrim.status = .success(Localizable.allCorrect)
		return true
	}
	
	static func validateEmail(email: inout ForgotPasswordState.Field<String>) -> Bool {
		guard EmailValidator.isValidEmail(email: email.value) else {
			email.status = .error(Localizable.incorrectEmail)
			return false
		}
		email.status = .success(Localizable.allCorrect)
		return true
	}
}
