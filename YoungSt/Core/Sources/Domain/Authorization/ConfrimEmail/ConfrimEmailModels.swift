//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture
import Coordinator

struct ConfrimEmailState: Equatable, ClosableState {
	var code = ""
	var userId: String = ""
	var isCodeVerified: Bool = false
	var alert: AlertState<ConfrimEmailAction>?
	var isClosed = false
}

enum ConfrimEmailAction: Equatable {
	case didCodeStartEnter(String)
	case failedValidation(String)
	case didConfrimButtonTapped
	case handleConfrimation(Result<Bool, ConfrimCodeError>)
	case alertOkButtonTapped
}

struct ConfrimEmailEnviroment {
	let authorizationService: AuthorizationService?
}
