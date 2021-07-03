//
//  File.swift
//  
//
//  Created by Роман Тищенко on 22.06.2021.
//

import Foundation
import NetworkService
import ComposableArchitecture
import Coordinator
import Utilities

struct LoginState: Equatable {
    enum Routing: Equatable {
        case forgotPassword(String)
        case confirmEmail(userId: UUID, email: String, password: String)
    }
    var email: StatusField<String> = .init(value: "", status: .default)
    var password: StatusField<String> = .init(value: "", status: .default)
    var resetPasswordOpened = false
    var isSecure: Bool = true
    var isLoading = false
    var routing: Routing?
    var loginFieldForceFocused: Bool = false
    var passwordFieldForceFocused: Bool = false
    
    var alertState: AlertState<LoginAction>?
}

enum LoginAction: Equatable {
    case emailChanged(String)
    case passwordChanged(String)
    case loginTapped
    case forgotPasswordTapped
    case showPasswordButtonTapped
    case handleLogin(Result<Authorization_LoginResponse, LoginError>)
    case alertClosed
    case routingHandled
    case loginInputFocusChanged(Bool)
    case passwordInputFocusChanged(Bool)
}

struct LoginEnviroment {
    let service: AuthorizationService
}
