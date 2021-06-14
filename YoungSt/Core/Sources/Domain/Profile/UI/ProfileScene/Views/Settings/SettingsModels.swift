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

enum SettingsAction: Equatable {
    
    case logoutPressed
    case logoutConfirmed
    
    case alertClosed
}

struct SettingsEnvironment {
    let bag: CancellationBag
    
    let credentialsService: CredentialsService
}
