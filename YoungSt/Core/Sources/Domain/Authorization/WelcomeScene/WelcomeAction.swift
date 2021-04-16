//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation

enum WelcomeAction: Equatable {
    case login(action: LoginAction)
    case registration(action: RegistrationAction)
}
