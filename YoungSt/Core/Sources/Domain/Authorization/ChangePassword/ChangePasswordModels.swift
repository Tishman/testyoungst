//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import Coordinator
import NetworkService
import Utilities
import ComposableArchitecture

struct ChangePasswordInput {
    let email: String
    let code: String
}

struct ChangePasswordState: Equatable {
    let email: String
    let code: String
    var password: String = ""
    var confirmPassword: String = ""
    var passwordFieldForceFocused: Bool = false
    var confirmPasswordFieldForceFocused: Bool = false
    var isLoading: Bool = false
    var alert: AlertState<ChangePasswordAction>?
    var routing: Routing?
    var isPasswordChanged: Bool = false
    var isPasswordSecure: Bool = true
    var isConfirmPasswordSecure: Bool = true
    
    enum Routing: Equatable {
        case passwordChanged
    }
}

enum ChangePasswordAction: Equatable {
    case passswordUpdated(String)
    case confirmPasswordUpdated(String)
    case changePasswordButtonTapped
    case passwordInputFocusChanged(Bool)
    case confirmPasswordInputFocusChanged(Bool)
    case handleResetPasswordResult(Result<EmptyResponse, EquatableError>)
    case alertOkButtonTapped
    case routingHandled
    case showPasswordButtonTapped
    case showConfirmPasswordButtonTapped
    case passwordReturnKeyTriggered
    case confirmPasswordReturnKeyTriggered
}

struct ChangePasswordEnviroment {
    let authorizationService: AuthorizationService
}
