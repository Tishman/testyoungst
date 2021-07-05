//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import Protocols
import Utilities

enum WelcomeAction: Equatable, AnalyticsAction {
	case route(Routing)
	
	enum Routing: Equatable, AnalyticsAction {
        case handled
        
		case login
		case registration
        
        var event: AnalyticsEvent? {
            switch self {
            case .login:
                return "login"
            case .registration:
                return "registration"
            case .handled:
                return nil
            }
        }
	}
    
    var event: AnalyticsEvent? {
        switch self {
        case let .route(routing):
            return routing.event?.route()
        }
    }
}
