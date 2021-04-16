//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation

struct WelcomeState: Equatable {
	var loginState: LoginState = .init()
	var registrationState: RegistrationState = .init()
}
