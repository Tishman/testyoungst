//
//  AppModels.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import Protocols
import Utilities

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
    let bag: CancellationBag
    let userProvider: UserProvider
    let credentialsService: CredentialsService
}
