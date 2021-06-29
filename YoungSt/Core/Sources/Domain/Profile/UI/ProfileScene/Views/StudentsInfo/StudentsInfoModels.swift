//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import NetworkService
import Protocols

struct StudentsInfoState: Equatable {
    
    var incomingInvites: IdentifiedArrayOf<IncomingStudentInviteState> = []
    var outcomingInvites: IdentifiedArrayOf<OutcomingStudentInviteState> = []
    var students: IdentifiedArrayOf<ProfileInfo> = []
    
    var isLoading = false
    var alert: AlertState<StudentsInfoAction>?
    
    var shouldShowLoader: Bool {
        isLoading && !hasInvites && students.isEmpty
    }
    
    var hasInvites: Bool {
        !incomingInvites.isEmpty || !outcomingInvites.isEmpty
    }
    
    var isEmpty: Bool {
        !hasInvites && students.isEmpty
    }
}

enum StudentsInfoAction: Equatable {
    case viewAppeared
    case updateList
    case alertClosed
    case searchStudentsOpened
    
    case studentRemove(Result<UUID, EquatableError>)
    case studentInfoUpdated(Result<Profile_GetStudentsResponse, EquatableError>)
    
    case incomingStudentInvite(id: UUID, action: IncomingStudentInviteAction)
    case outcomingStudentInvite(id: UUID, action: OutcomingStudentInviteAction)
    case student(id: UUID, action: StudentAction)
    
    enum StudentAction: Equatable {
        case remove
        case open
    }
}

struct StudentsInfoEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
    let profileEventPublisher: ProfileEventPublisher
    
    var incomingStudentInviteEnv: IncomingStudentInviteEnvironment {
        .init(bag: bag,
              inviteService: inviteService)
    }
    
    var outcomingStudentInviteEnv: OutcomingStudentInviteEnvironment {
        .init(bag: bag,
              inviteService: inviteService)
    }
}
