//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture
import Coordinator
import Utilities
import NetworkService

struct ConfrimEmailState: Equatable, ClosableState {
	var code = ""
	var userId: UUID
	var credentails: ConfirmEmailInput.Credentials
	var isCodeVerified: Bool = false
	var alert: AlertState<ConfrimEmailAction>?
	var isClosed = false
	var isLoading = false
}

enum ConfrimEmailAction: Equatable {
	case didCodeStartEnter(String)
	case failedValidation(String)
	case didConfrimButtonTapped
	case handleConfrimation(Result<Bool, EquatableError>)
	case handleLogin(Result<Authorization_LoginResponse, LoginError>)
	case alertOkButtonTapped
}

struct ConfrimEmailEnviroment {
	let authorizationService: AuthorizationService?
}
