//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation

enum WelcomeAction: Equatable {
    case login(LoginAction)
    case registration(RegistrationAction)
	case loginOpenned(Bool)
	case registrationOppend(Bool)
}
