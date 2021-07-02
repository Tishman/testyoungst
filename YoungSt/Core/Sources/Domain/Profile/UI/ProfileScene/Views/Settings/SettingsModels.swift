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
    
}

enum SettingsAction: Equatable, AnalyticsAction {
    
    case logoutTriggered
    case logoutConfirmTriggered
    
    case alertClosedTriggered
    
    var event: AnalyticsEvent? {
        switch self {
        case .logoutConfirmTriggered:
            return "logoutConfirmTriggered"
        default:
            return nil
        }
    }
}

struct SettingsEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    
    let credentialsService: CredentialsService
    let analyticsService: AnalyticService
}
