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
    
    enum Route: Equatable {
        case fillInfo
        case editProfile
        case shareProfile(userID: UUID)
        case openedStudent(userID: UUID)
    }
    
    let userID: UUID
    var currentProfileState: CurrentProfileState
    var route: Route?
    
    init(userID: UUID, currentProfileState: CurrentProfileState? = nil) {
        self.userID = userID
        self.currentProfileState = currentProfileState ?? .init(id: userID)
    }
    
    var profileType: ProfileTypeState = .student
    var selectedTab: Tab = .settings
    
    var teacherInfoState: TeacherInfoState = .loading
    var studentsInfoState: StudentsInfoState = .init()
    var settingsState = SettingsState()
    
    static var preview: Self = .init(userID: .init(), currentProfileState: .preview)
}

enum ProfileAction: Equatable {
    case viewAppeared
    case profileTypeChanged(ProfileState.ProfileTypeState)
    
    case changeSelectedTab(Int)
    case selectedTabShanged(ProfileState.Tab)
    
    case currentProfile(CurrentProfileAction)
    case teacherInfo(TeacherInfoAction)
    case studentsInfo(StudentsInfoAction)
    case settings(SettingsAction)
    
    
    enum DetailState: Equatable {
        case closed
        case editProfile
        case fillInfo
        case shareProfile
        case openStudent(UUID)
    }
    
    case changeDetail(DetailState)
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
              userProvider: userProvider,
              credentialsService: credentialsService)
    }
    
    var teacherInfoEnv: TeacherInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService)
    }
    
    var studentsInfoEnv: StudentsInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService)
    }
    
    var settingsEnv: SettingsEnvironment {
        .init(bag: .autoId(childOf: bag),
              credentialsService: credentialsService)
    }
}
