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
import Protocols

enum LoginField {
    case email
    case password
}

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

enum LoginAction: Equatable, AnalyticsAction {
    case emailChanged(String)
    case passwordChanged(String)
    case loginTriggered
    case forgotPasswordTriggered
    case showPasswordButtonTriggered
    case alertClosedTriggered
    
    case routingHandled
    case loginInputFocusChanged(Bool)
    case passwordInputFocusChanged(Bool)
    case fieldSubmitted(LoginField)
    
    case handleLogin(Result<Authorization_LoginResponse, LoginError>)
    
    var event: AnalyticsEvent? {
        switch self {
        case .emailChanged:
            return .init(name: "emailChanged", oneTimeEvent: true)
        case .passwordChanged:
            return .init(name: "passwordChanged", oneTimeEvent: true)
        case .loginTriggered:
            return "loginTriggered"
        case .forgotPasswordTriggered:
            return "forgotPasswordTriggered"
        case .showPasswordButtonTriggered:
            return "showPasswordButtonTriggered"
        case .alertClosedTriggered:
            return "alertClosedTriggered"
        case let .handleLogin(result):
            return .init(name: "loginResult", parameters: AnalyticParameter.result(result).toDict)
        default:
            return nil
        }
    }
}

struct LoginEnviroment: AnalyticsEnvironment {
    let analyticsService: AnalyticService
    let service: AuthorizationService
}
