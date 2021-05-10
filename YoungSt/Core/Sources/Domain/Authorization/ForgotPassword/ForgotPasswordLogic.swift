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

let reducer = Reducer<ForgotPasswordState, ForgotPasswordAction, ForgotPasswordEnviroment> { state, action, enviroment in
	switch action {
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
		state.isPasswordHidden.toggle()
		
	case .confrimPasswordButtonTapped:
		state.isConfrimPasswordHidden.toggle()
		
	case .didChangePasswordButtonTapped:
		
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
		break
		
	case let .handleResetPassword(.success(isPasswordChanged)):
		state.isResetPasswordInit = true
		
	case let .handleResetPassword(.failure(error)):
		break
		
	case .alertOkButtonTapped:
		state.alert = nil
		
	case .didSendCodeButtonTapped:
		guard !state.email.value.isEmpty && EmailValidator.isValidEmail(email: state.email.value) else {
			state.email.status = .error(Localizable.incorrectEmail)
			break
		}
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
