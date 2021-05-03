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
}

enum ForgotPasswordAction {
	case didEmailEditing(String)
	case clearEmail
	case didSendEmailButtonTapped
	case handleEmailSend(Result<EmptyResponse, ResetPasswordError>)
}

struct ForgotPasswordEnviroment {
	let authorizationService: AuthorizationService
}
