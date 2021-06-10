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
import Coordinator
import NetworkService

struct ShareProfileState: Equatable, ClosableState {
    let userID: UUID
    
    var url: String = ""
    var isLoading = false
    var alert: AlertState<ShareProfileAction>?
    
    var shareURL: URL?
    var isClosed: Bool = false
}

enum ShareProfileAction: Equatable {
    case viewAppeared
    case copy
    case shareOpened(Bool)
    case shareGenerated(Result<Profile_GenerateSharedTeacherInviteResponse, EquatableError>)
    case alertClosed
}

struct ShareProfileEnvironment {
    let bag: CancellationBag
    
    let deeplinkService: DeeplinkService
    let inviteService: InviteService
}
