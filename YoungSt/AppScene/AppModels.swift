//
//  AppModels.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import Protocols
import Utilities
import Coordinator

struct AppState: Equatable {
    
    enum UIState: Equatable {
        case onboarding
        case authorization
        case authorized(UUID, Bool)
    }
    
    var uiState: UIState = .authorization
    var pendingDeeplink: Deeplink?
    
    var deeplink: Deeplink?
}

enum AppAction: Equatable {
    case appLaunched
    case authorized(userID: UUID)
    case unauthorized
    case handleDeeplink(Deeplink)
    case deeplinkHandled
}

struct AppEnviroment {
    let bag: CancellationBag
    let userProvider: UserProvider
    let credentialsService: CredentialsService
}
