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

extension CurrentProfileInfo: Previwable {
    public static let preview: Self = .init(firstName: "Max", lastName: "Rakotanski")
}

struct CurrentProfileState: Equatable, Previwable {
    
    enum InfoState: Equatable, Previwable {
        case loading
        case infoRequired
        case infoProvided(CurrentProfileInfo)
        
        static var preview: Self = .infoProvided(.preview)
    }
    
    let id: UUID
    var infoState: InfoState = .loading
    var nickname: String?
    
    var avatarSource: ProfileAvatarSource {
        switch infoState {
        case let .infoProvided(info):
            return .init(id: id, first: info.firstName, last: info.lastName)
        default:
            return .init(id: id, title: nickname ?? "")
        }
    }
    
    var isInfoProvided: Bool {
        if case .infoProvided = infoState {
            return true
        }
        return false
    }
    
    static var preview: Self = .init(id: .init(), infoState: .preview, nickname: "@mrakotanski")
}

enum CurrentProfileAction: Equatable {
    case viewAppeared
    case profileUpdateRequested
    case profileUpdated(Result<Profile_GetOwnProfileInfoResponse, EquatableError>)
    case userInfoUpdated(UserInfo)
    case editInfoOpened
}

struct CurrentProfileEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let userProvider: UserProvider
    let credentialsService: CredentialsService
}
