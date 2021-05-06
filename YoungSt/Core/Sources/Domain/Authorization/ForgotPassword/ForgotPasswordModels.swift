//
//  File.swift
//  
//
//  Created by Роман Тищенко on 02.05.2021.
//

import Foundation
import NetworkService
import Utilities

struct ForgotPasswordState: Equatable {
	var email = ""
	var code = ""
	var confrimCode = ""
	var userMessage = ""
}

enum ForgotPasswordAction {
	case didEmailEditing(String)
	case didCodeEditing(String)
	case clearEmail
	case didSendCodeButtonTapped
	case didConfrimButtonTapped
	case handleEmailSend(Result<EmptyResponse, InitResetPasswordError>)
}

struct ForgotPasswordEnviroment {
	let authorizationService: AuthorizationService
}
