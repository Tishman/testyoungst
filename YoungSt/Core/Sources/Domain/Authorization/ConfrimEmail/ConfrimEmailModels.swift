//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture

struct ConfrimEmailState: Equatable {
	var code = ""
	var userId: String = ""
	var isCodeVerified: Bool = false
	var isAlertPresent: Bool = false
	var alertMessage = ""
}

enum ConfrimEmailAction: Equatable {
	case didCodeStartEnter(String)
	case failedValidation(String)
	case alertPresented
	case didConfrimButtonTapped
	case handleConfrimation(Result<Bool, ConfrimCodeError>)
	case finishRegistartion
}

struct ConfrimEmailEnviroment {
	let authorizationService: AuthorizationService?
}
