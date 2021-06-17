//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import NetworkService

enum RegistrationAction: Equatable {
    case didEmailChanged(String)
    case didNicknameChange(String)
    case didPasswordChanged(String)
    case didConfrimPasswordChanged(String)
    case registrationButtonTapped
    case didRecieveRegistartionResult(Result<UUID, RegistrationError>)
	case failedValidtion(String)
	case alertClosed
	case showPasswordButtonTapped
    case showConfrimPasswordButtonTapped
	case routingHandled
    case emailInputFocusChanged(Bool)
    case userNameInputFocusChanged(Bool)
    case passwordInputFocusChanged(Bool)
    case confirmPasswordInputFocusChanged(Bool)
}
