//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Protocols

struct SettingsState: Equatable {
    
    var alert: AlertState<SettingsAction>?
    var routing: Routing?
    
    enum Routing: Equatable {
        case mail(Mail)
    }
    
    struct Mail: Equatable {
        let recipient: String
        let subject: String
        let body: String
    }
}

enum SettingsAction: Equatable, AnalyticsAction {
    
    case logoutTriggered
    case logoutConfirmTriggered
    
    case alertClosedTriggered
    case route(Routing)
    
    enum Routing: Equatable, AnalyticsAction {
        case handled
        case mail
        
        var event: AnalyticsEvent? {
            switch self {
            case .mail:
                return "mail"
            case .handled:
                return nil
            }
        }
    }
    
    var event: AnalyticsEvent? {
        switch self {
        case .logoutConfirmTriggered:
            return "logoutConfirmTriggered"
        case let .route(routing):
            return routing.event?.route()
        default:
            return nil
        }
    }
}

struct SettingsEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    
    let credentialsService: CredentialsService
    let analyticsService: AnalyticService
    let userProvider: UserProvider
}
