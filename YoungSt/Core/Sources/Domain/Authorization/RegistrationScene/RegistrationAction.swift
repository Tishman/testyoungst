//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import NetworkService
import Utilities
import Protocols

enum RegistrationField: Equatable {
    case email
    case nickname
    case password
    case confirmPassword
}

enum RegistrationAction: Equatable, AnalyticsAction {
    case didEmailChanged(String)
    case didNicknameChange(String)
    case didPasswordChanged(String)
    case didConfrimPasswordChanged(String)
    case emailInputFocusChanged(Bool)
    case userNameInputFocusChanged(Bool)
    case passwordInputFocusChanged(Bool)
    case confirmPasswordInputFocusChanged(Bool)
    
    case registrationTriggered
	case alertClosedTriggered
	case showPasswordTriggered
    case showConfrimPasswordTriggered
    case fieldSubmitted(RegistrationField)
    
	case routingHandled
    
    case didRecieveRegistartionResult(Result<UUID, RegistrationError>)
    case failedValidtion(String)
    
    var event: AnalyticsEvent? {
        switch self {
        case .didEmailChanged:
            return .init(name: "didEmailChanged", oneTimeEvent: true)
        case .didNicknameChange:
            return .init(name: "didNicknameChange", oneTimeEvent: true)
        case .didPasswordChanged:
            return .init(name: "didPasswordChanged", oneTimeEvent: true)
        case .didConfrimPasswordChanged:
            return .init(name: "didConfrimPasswordChanged", oneTimeEvent: true)
            
        case .registrationTriggered:
            return "registrationTriggered"
        case .alertClosedTriggered:
            return "alertClosedTriggered"
        case .showPasswordTriggered:
            return "showPasswordTriggered"
        case .showConfrimPasswordTriggered:
            return "showConfrimPasswordTriggered"
        case let .didRecieveRegistartionResult(result):
            return .init(name: "registartionResult", parameters: AnalyticParameter.result(result).toDict)
        default:
            return nil
        }
    }
}
