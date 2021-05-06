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

let reducer = Reducer<ForgotPasswordState, ForgotPasswordAction, ForgotPasswordEnviroment> { state, action, enviroment in
	switch action {
	case .clearEmail:
		state.email = ""
		
	case let .didEmailEditing(value):
		state.email = value
		
	case .didSendCodeButtonTapped:
		let requestData = Authorization_InitResetPasswordRequest.with {
			$0.email = state.email
		}
		
		return enviroment.authorizationService.initResetPassword(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ForgotPasswordAction.handleEmailSend)
		
	case .handleEmailSend(.success):
		break
		
	case .handleEmailSend(.failure):
		state.userMessage = Localizable.incorrectEmail
		
	case .didCodeEditing(_):
		break
	case .didConfrimButtonTapped:
		break
	}
	return .none
}
