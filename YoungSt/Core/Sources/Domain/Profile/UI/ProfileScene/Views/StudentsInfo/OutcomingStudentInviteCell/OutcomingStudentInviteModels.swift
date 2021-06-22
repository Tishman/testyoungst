//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import NetworkService

struct OutcomingStudentInviteState: Identifiable, Equatable, Previwable {
    let id: UUID
    let profile: ProfileInfo
    var isLoading = false
    
    static let preview: Self = .init(id: .init(), profile: .preview, isLoading: false)
}

enum OutcomingStudentInviteAction: Equatable {
    case rejectInvite
    case inviteRejected(Result<EmptyResponse, EquatableError>)
}

struct OutcomingStudentInviteEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
}
