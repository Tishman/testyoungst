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
    case registerButtonTapped
    case showPasswordButtonTapped
    case handleLogin(Result<Authorization_LoginResponse, LoginError>)
}
