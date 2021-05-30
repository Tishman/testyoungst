//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import NetworkService

enum LoginAction: Equatable {
    case emailChanged(String)
    case passwordChanged(String)
    case loginTapped
    case forgotPasswordTapped
    case showPasswordButtonTapped
    case handleLogin(Result<Authorization_LoginResponse, LoginError>)
	case alertClosed
	case failedValidtion(String)
	case routingHandled
}
