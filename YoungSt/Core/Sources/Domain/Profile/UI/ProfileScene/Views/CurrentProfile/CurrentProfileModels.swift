//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import Protocols
import NetworkService

struct CurrentProfileState: Equatable, Previwable {
    
    enum InfoState: Equatable, Previwable {
        case loading
        case infoRequired
        case infoProvided(ProfileInfo)
        
        struct ProfileInfo: Equatable, Previwable {
            let firstName: String
            let lastName: String
            
            static let preview: Self = .init(firstName: "Max", lastName: "Rakotanski")
        }
        
        static var preview: Self = .infoProvided(.preview)
    }
    
    var infoState: InfoState = .loading
    var nickname: String?
    
    static var preview: Self = .init(infoState: .preview, nickname: "@mrakotanski")
}

enum CurrentProfileAction: Equatable {
    case viewAppeared
    case profileUpdateRequested
    case profileUpdated(Result<Profile_GetOwnProfileInfoResponse, EquatableError>)
    case editInfoOpened(Bool)
}

struct CurrentProfileEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let userProvider: UserProvider
}
