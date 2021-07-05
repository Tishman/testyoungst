//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture
import Coordinator
import Utilities
import NetworkService
import Protocols

struct ConfrimEmailInput {
    let userId: UUID
    let email: String
    let password: String
}

struct ConfrimEmailState: Equatable, ClosableState {
	let userId: UUID
    let email: String
    let passsword: String
	var isCodeVerified: Bool = false
	var alert: AlertState<ConfrimEmailAction>?
	var isClosed = false
	var isLoading = false
    var codeEnter: CodeEnterState = .init(codeCount: 6)
}

enum ConfrimEmailAction: Equatable, AnalyticsAction {
    case viewAppeared
    
	case failedValidation(String)
    
	case didConfrimTriggered
    case alertClosedTriggered
    
	case handleConfrimation(Result<Bool, EquatableError>)
	case handleLogin(Result<Authorization_LoginResponse, LoginError>)
    
    case codeEnter(CodeEnterAction)
    
    var event: AnalyticsEvent? {
        switch self {
        case .didConfrimTriggered:
            return "didConfrimTriggered"
        case .alertClosedTriggered:
            return "didConfrimTriggered"
        case let .handleConfrimation(result):
            return .init(name: "confirmResult", parameters: AnalyticParameter.result(result).toDict)
        case let .handleLogin(result):
            return .init(name: "loginResult", parameters: AnalyticParameter.result(result).toDict)
        default:
            return nil
        }
    }
}

struct ConfrimEmailEnviroment: AnalyticsEnvironment {
    let analyticsService: AnalyticService
	let authorizationService: AuthorizationService?
}
