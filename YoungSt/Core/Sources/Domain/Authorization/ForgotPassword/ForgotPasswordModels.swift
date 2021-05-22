//
//  File.swift
//  
//
//  Created by Роман Тищенко on 02.05.2021.
//

import Foundation
import NetworkService
import Utilities
import ComposableArchitecture

struct ForgotPasswordState: Equatable {
	var email: Field<String> = .init(value: "", status: .default)
	var code: Field<String> = .init(value: "", status: .default)
	var password: Field<String> = .init(value: "", status: .default)
	var confrimPassword: Field<String> = .init(value: "", status: .default)
	var isPasswordHidden = true
	var isConfrimPasswordHidden = true
	var isResetPasswordInit = false
	var isPasswordChanged = false
	var alert: AlertState<ForgotPasswordAction>?
}

extension ForgotPasswordState {
	struct Field<T: Equatable>: Equatable {
		var value: T
		var status: TextEditStatus
		
		static func == (lhs: ForgotPasswordState.Field<T>, rhs: ForgotPasswordState.Field<T>) -> Bool {
			return lhs.value == rhs.value && lhs.status == rhs.status
		}
	}
}

enum ForgotPasswordAction: Equatable {
	case didEmailEditing(String)
	case didCodeEditing(String)
	case didPasswordEditing(String)
	case didConrimPasswordEditing(String)
	case passwordButtonTapped
	case confrimPasswordButtonTapped
	case didSendCodeButtonTapped
	case didChangePasswordButtonTapped
	case handleInitResetPassword(Result<EmptyResponse, InitResetPasswordError>)
	case handleResetPassword(Result<EmptyResponse, ResetPasswordError>)
	case alertOkButtonTapped
}

struct ForgotPasswordEnviroment {
	let authorizationService: AuthorizationService
}
