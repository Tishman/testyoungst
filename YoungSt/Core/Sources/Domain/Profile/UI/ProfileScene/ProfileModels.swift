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
    }
    
    enum Route: Equatable {
        case fillInfo
        case editProfile
        case searchTeacher
        case searchStudents
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
    
    var teacherInfoState: TeacherInfoState = .init()
    var studentsInfoState: StudentsInfoState = .init()
    
    static var preview: Self = .init(userID: .init(), currentProfileState: .preview)
}

enum ProfileAction: Equatable, AnalyticsAction {
    case viewAppeared
    case refreshTriggered
    case profileTypeChanged(ProfileState.ProfileTypeState)
    
    case currentProfile(CurrentProfileAction)
    case teacherInfo(TeacherInfoAction)
    case studentsInfo(StudentsInfoAction)
    
    enum Routing: Equatable, AnalyticsAction {
        case handled
        
        case editProfile
        case fillInfo
        case openStudent(UUID)
        
        var event: AnalyticsEvent? {
            switch self {
            case .editProfile:
                return "editProfile"
            case .fillInfo:
                return "fillInfo"
            case .openStudent:
                return "openStudent"
            case .handled:
                return nil
            }
        }
    }
    
    case route(Routing)
    
    var event: AnalyticsEvent? {
        switch self {
        case .refreshTriggered:
            return .init(name: CommonEvent.refreshTriggered.rawValue)
        case let .route(routing):
            return routing.event?.route()
        case let .profileTypeChanged(state):
            return .init(name: "profileTypeChanged", parameters: ["profile_type": state])
        default:
            return nil
        }
    }
}

struct ProfileEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
    let userProvider: UserProvider
    let storage: KeyValueStorage
    let deeplinkService: DeeplinkService
    let credentialsService: CredentialsService
    let profileEventPublisher: ProfileEventPublisher
    let analyticsService: AnalyticService
    
    var currentProfileEnv: CurrentProfileEnvironment {
        .init(bag: .autoId(childOf: bag),
              profileService: profileService,
              userProvider: userProvider,
              credentialsService: credentialsService)
    }
    
    var teacherInfoEnv: TeacherInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService,
              profileEventPublisher: profileEventPublisher)
    }
    
    var studentsInfoEnv: StudentsInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              inviteService: inviteService,
              profileEventPublisher: profileEventPublisher)
    }
}
