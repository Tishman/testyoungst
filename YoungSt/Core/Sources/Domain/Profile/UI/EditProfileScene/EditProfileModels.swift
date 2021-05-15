//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import Protocols
import NetworkService

struct EditProfileState: Equatable, Previwable {
    let shouldFetchProfile: Bool
    
    var firstName = ""
    var firstNameError: String?
    
    var lastName = ""
    
    var nickname = ""
    var nicknameError: String?
    
    var isLoading = false
    var alert: AlertState<EditProfileAction>?
    
    static let preview: Self = .init(shouldFetchProfile: false, firstName: "Max", lastName: "Rakotanski", nickname: "mrakotanski")
}

enum EditProfileAction: Equatable {
    case viewAppeared
    case updateProfileRequested
    
    case firstNameChanged(String)
    case lastNameChanged(String)
    case nicknameChanged(String)
    
    case editProfileTriggered
    case alertClosed
    
    case profileFetched(Result<Profile_GetOwnProfileInfoResponse, EquatableError>)
    case profileEdited(Result<Profile_UpdateProfileResponse, EquatableError>)
    
    case closeSceneTriggered
}

struct EditProfileEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let userProvider: UserProvider
}
