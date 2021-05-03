//
//  AppModels.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import Protocols

struct AppState: Equatable {
    
    var authorizedState: TabState?
    
}


enum AppAction: Equatable {
    case appLaunched
    case authorized(userID: UUID)
    case unauthorized
    
    case tab(TabAction)
}

struct AppEnviroment {
    let userProvider: UserProvider
    let credentialsService: CredentialsService
}
