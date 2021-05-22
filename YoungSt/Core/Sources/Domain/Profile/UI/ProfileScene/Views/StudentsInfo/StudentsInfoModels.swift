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

struct StudentsInfoState: Equatable {
    
    var studentsInvites: IdentifiedArrayOf<IncomingStudentInviteState> = []
    var students: [ProfileInfo] = []
    
    var isLoading = false
    var alert: AlertState<StudentsInfoAction>?
    
    var shouldShowLoader: Bool {
        isLoading && studentsInvites.isEmpty && students.isEmpty
    }
}

enum StudentsInfoAction: Equatable {
    case viewAppeared
    case updateList
    case alertClosed
    
    case studentOpened(UUID)
    case removeStudentTriggered(UUID)
    
    case studentRemove(Result<UUID, EquatableError>)
    case studentInfoUpdated(Result<Profile_GetStudentsResponse, EquatableError>)
    
    case incomingStudentInvite(id: UUID, action: IncomingStudentInviteAction)
}

struct StudentsInfoEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
    
    var incomingStudentInviteEnv: IncomingStudentInviteEnvironment {
        .init(bag: bag,
              inviteService: inviteService)
    }
}
