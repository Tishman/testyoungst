//
//  AppModels.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import Protocols

struct AppState: Equatable {
    
    var authorizedState: AuthorizedState?
    
}

extension AppState {
    
    struct AuthorizedState: Equatable {
        let userID: UUID
        var selectedTab: SelectedTab = .dictionaries
        
        enum SelectedTab:Equatable {
            case dictionaries
            case profile
        }
    }
}


enum AppAction: Equatable {
    case appLaunched
    case authorized(userID: UUID)
    case unauthorized
}

struct AppEnviroment {
    let userProvider: UserProvider
    let credentialsService: CredentialsService
}
