//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import NetworkService

struct IncomingStudentInviteState: Identifiable, Equatable, Previwable {
    let id: UUID
    let student: ProfileInfo
    var loading: Loading?
    
    enum Loading: Equatable {
        case accept
        case reject
    }
    
    static let preview: Self = .init(id: .init(), student: .preview, loading: nil)
}

enum IncomingStudentInviteAction: Equatable {
    case acceptInvite
    case rejectInvite
    
    case inviteAccepted(Result<EmptyResponse, EquatableError>)
    case inviteRejected(Result<EmptyResponse, EquatableError>)
}

struct IncomingStudentInviteEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
}
