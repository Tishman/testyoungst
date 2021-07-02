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
	var email: StatusField<String> = .init(value: "", status: .default)
	var isClosed = false
	var alert: AlertState<ForgotPasswordAction>?
    var emailFieldForceFocused: Bool = false
    var routing: Routing?
    var isLoading: Bool = false
    
    enum Routing: Equatable {
        case verification(email: String)
    }
}

enum ForgotPasswordAction: Equatable {
	case didEmailEditing(String)
	case didSendCodeButtonTapped
	case handleInitResetPassword(Result<EmptyResponse, EquatableError>)
	case alertOkButtonTapped
    case emailInputFocusChanged(Bool)
    case routingHandled
}

struct ForgotPasswordEnviroment {
	let authorizationService: AuthorizationService
}
