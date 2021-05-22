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
    
    enum DetailState: Equatable {
        case fillInfo(EditProfileState)
        case editProfile(EditProfileState)
        case shareProfile(ShareProfileState)
        case openedStudent(UUID)
    }
    
    let userID: UUID
    var currentProfileState: CurrentProfileState
    
    init(userID: UUID, currentProfileState: CurrentProfileState? = nil) {
        self.userID = userID
        self.currentProfileState = currentProfileState ?? .init(id: userID)
    }
    
    var profileType: ProfileTypeState = .student
    var selectedTab: Tab = .settings
    
    var detailState: DetailState?
    
    var teacherInfoState: TeacherInfoState = .loading
    var studentsInfoState: StudentsInfoState = .init()
    
    static var preview: Self = .init(userID: .init(), currentProfileState: .preview)
}

extension ProfileState {
    
    var fillInfoState: EditProfileState? {
        get {
            switch detailState {
            case let .fillInfo(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .fillInfo:
                detailState = .fillInfo(newValue)
            default:
                break
            }
        }
    }
    
    var editProfileState: EditProfileState? {
        get {
            switch detailState {
            case let .editProfile(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .editProfile:
                detailState = .editProfile(newValue)
            default:
                break
            }
        }
    }
    
    var shareProfileState: ShareProfileState? {
        get {
            switch detailState {
            case let .shareProfile(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .shareProfile:
                detailState = .shareProfile(newValue)
            default:
                break
            }
        }
    }
    
    var studentInfoState: UUID? {
        get {
            switch detailState {
            case let .openedStudent(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .openedStudent:
                detailState = .openedStudent(newValue)
            default:
                break
            }
        }
    }
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
    
    
    enum DetailState: Equatable {
        case closed
        case editProfile
        case fillInfo
        case shareProfile
        case openStudent(UUID)
    }
    
    case changeDetail(DetailState)
    
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
