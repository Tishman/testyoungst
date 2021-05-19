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
import Resources
import Coordinator

struct ProfileState: Equatable, Previwable {
    
    enum Tab: Int, Identifiable, Hashable {
        case settings
        case teacher
        case students
        
        var title: String {
            switch self {
            case .settings:
                return Localizable.settings
            case .teacher:
                return Localizable.teacher
            case .students:
                return Localizable.students
            }
        }
        
        var id: Self { self }
    }
    
    enum ProfileTypeState: Int, Identifiable, Hashable {
        case teacher
        case student
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .teacher:
                return Localizable.teacher
            case .student:
                return Localizable.student
            }
        }
        
        var tabs: [Tab] {
            switch self {
            case .student:
                return [.settings, .teacher]
            case .teacher:
                return [.settings, .students]
            }
        }
    }
    
    let userID: UUID
    var currentProfileState: CurrentProfileState
    
    init(userID: UUID, currentProfileState: CurrentProfileState? = nil) {
        self.userID = userID
        self.currentProfileState = currentProfileState ?? .init(id: userID)
    }
    
    var profileType: ProfileTypeState = .student
    var selectedTab: Tab = .settings
    
    var fillInfoState: EditProfileState?
    var editProfileState: EditProfileState?
    var shareProfileState: ShareProfileState?
    
    var teacherInfoState: TeacherInfoState = .loading
    var studentsInfoState: StudentsInfoState = .init()
    
    static var preview: Self = .init(userID: .init(), currentProfileState: .preview)
}

enum ProfileAction: Equatable {
    case viewAppeared
    case profileTypeChanged(ProfileState.ProfileTypeState)
    
    case changeSelectedTab(Int)
    case selectedTabShanged(ProfileState.Tab)
    
    case currentProfile(CurrentProfileAction)
    case fillProfileInfo(EditProfileAction)
    case editProfile(EditProfileAction)
    case teacherInfo(TeacherInfoAction)
    case studentsInfo(StudentsInfoAction)
    case shareProfile(ShareProfileAction)
    
    case editProfileOpened
    case fillInfoClosed
    case editProfileClosed
    case shareProfileOpened(Bool)
    
    case logout
}

struct ProfileEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
    let userProvider: UserProvider
    let storage: KeyValueStorage
    let deeplinkService: DeeplinkService
    let credentialsService: CredentialsService
    
    var currentProfileEnv: CurrentProfileEnvironment {
        .init(bag: .autoId(childOf: bag),
              profileService: profileService,
              userProvider: userProvider)
    }
    
    func editProfileEnv(bag: CancellationBag) -> EditProfileEnvironment {
        .init(bag: bag,
              profileService: profileService,
              userProvider: userProvider)
    }
    
    var teacherInfoEnv: TeacherInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService)
    }
    
    var studentsInfoEnv: StudentsInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService)
    }
    
    var shareProfileEnv: ShareProfileEnvironment {
        .init(bag: .autoId(childOf: bag),
              deeplinkService: deeplinkService)
    }
}
