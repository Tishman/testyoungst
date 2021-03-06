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
import Coordinator

struct EditProfileState: Equatable, Previwable, ClosableState {
    let shouldFetchProfile: Bool
    
    var isClosed: Bool = false
    var firstName = ""
    var firstNameError: String?
    
    var lastName = ""
    
    var nickname = ""
    var nicknameError: String?
    
    var isLoading = false
    var alert: AlertState<EditProfileAction>?
    
    static let preview: Self = .init(shouldFetchProfile: false, firstName: "Max", lastName: "Rakotanski", nickname: "mrakotanski")
}

enum EditProfileAction: Equatable, AnalyticsAction {
    case viewAppeared
    
    case firstNameChanged(String)
    case lastNameChanged(String)
    case nicknameChanged(String)
    
    case editProfileTriggered
    case alertClosedTriggered
    case closeSceneTriggered
    
    case updateProfileRequested
    case profileFetched(Result<Profile_GetOwnProfileInfoResponse, EquatableError>)
    case profileEdited(Result<Profile_UpdateProfileResponse, EquatableError>)
    
    var event: AnalyticsEvent? {
        switch self {
        case .editProfileTriggered:
            return "editProfileTriggered"
        case .firstNameChanged:
            return .init(name: "firstNameChanged", oneTimeEvent: true)
        case .lastNameChanged:
            return .init(name: "lastNameChanged", oneTimeEvent: true)
        case .nicknameChanged:
            return .init(name: "nicknameChanged", oneTimeEvent: true)
        default:
            return nil
        }
    }
}

struct EditProfileEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let userProvider: UserProvider
    let analyticsService: AnalyticService
}
