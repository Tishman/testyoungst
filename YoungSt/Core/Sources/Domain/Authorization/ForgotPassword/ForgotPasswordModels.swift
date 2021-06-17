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
import Coordinator

struct ForgotPasswordState: Equatable, ClosableState {
	var email: Field<String> = .init(value: "", status: .default)
	var code: Field<String> = .init(value: "", status: .default)
	var password: Field<String> = .init(value: "", status: .default)
	var confrimPassword: Field<String> = .init(value: "", status: .default)
	var isPasswordHidden = true
	var isConfrimPasswordHidden = true
	var isResetPasswordInit = false
	var isPasswordChanged = false
	var isClosed = false
	var alert: AlertState<ForgotPasswordAction>?
    var emailFieldForceFocused: Bool = false
    var codeFieldForceFocused: Bool = false
    var passwordFieldForceFocused: Bool = false
    var confirmPasswordFieldForceFocused: Bool = false
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
    case emailInputFocusChanged(Bool)
    case codeInputFocusChanged(Bool)
    case passwordInputFocusChanged(Bool)
    case confirmPasswordInputFocusChanged(Bool)
}

struct ForgotPasswordEnviroment {
	let authorizationService: AuthorizationService
}
