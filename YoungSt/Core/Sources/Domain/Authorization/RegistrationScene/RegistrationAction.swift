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
	case confrimCode(ConfrimEmailAction)
	case confrimCodeClosed
	case showPasswordButtonTapped(SecureFieldType)
    case finishRegistration
	case routingHandled
	
	enum SecureFieldType {
		case password
		case confrimPassword
	}
}
