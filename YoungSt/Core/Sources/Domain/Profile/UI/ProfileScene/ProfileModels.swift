//
//  File.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Protocols

struct ProfileState: Equatable, Previwable {
    let userID: UUID
    var currentProfileState: CurrentProfileState = .init()
    
    static var preview: Self = .init(userID: .init(), currentProfileState: .preview)
}

enum ProfileAction: Equatable {
    case currentProfile(CurrentProfileAction)
}

struct ProfileEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let userProvider: UserProvider
    
    var currentProfileEnv: CurrentProfileEnvironment {
        .init(bag: .autoId(childOf: bag),
              profileService: profileService,
              userProvider: userProvider)
    }
}
