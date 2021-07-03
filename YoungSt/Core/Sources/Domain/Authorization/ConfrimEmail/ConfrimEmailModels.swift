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

struct ConfrimEmailInput {
    let userId: UUID
    let email: String
    let password: String
}

struct ConfrimEmailState: Equatable, ClosableState {
	let userId: UUID
    let email: String
    let passsword: String
	var isCodeVerified: Bool = false
	var alert: AlertState<ConfrimEmailAction>?
	var isClosed = false
	var isLoading = false
    var codeEnter: CodeEnterState = .init(codeCount: 6)
}

enum ConfrimEmailAction: Equatable {
	case failedValidation(String)
	case didConfrimButtonTapped
	case handleConfrimation(Result<Bool, EquatableError>)
	case handleLogin(Result<Authorization_LoginResponse, LoginError>)
	case alertOkButtonTapped
    case codeEnter(CodeEnterAction)
    case viewDidAppear
}

struct ConfrimEmailEnviroment {
	let authorizationService: AuthorizationService?
}
