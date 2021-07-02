//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import Coordinator
import NetworkService
import ComposableArchitecture
import Utilities

struct SearchStudentState: Equatable, ClosableState {
    var searchText = ""
    var isSearchLoading = false
    var isInviteSendingLoading = false
    var isClosed = false
    var routing: Routing?
    
    enum Routing: Equatable {
        case shareLink
    }
    
    var profileList: IdentifiedArrayOf<ProfileInfo> = []
    var alert: AlertState<SearchStudentAction>?
}

enum SearchStudentAction: Equatable {
    case searchTextChanged(String)
    case searchLoaded(Result<SearchResult, EquatableError>)
    case inviteSended(Result<EmptyResponse, EquatableError>)
    case alertClosed
    case profile(id: UUID, action: ProfileAction)
    case routingHandled
    case changeDetail(SearchStudentState.Routing)
    
    struct SearchResult: Equatable {
        let text: String
        let result: [ProfileInfo]
    }
    
    enum ProfileAction: Equatable {
        case selected
    }
}

struct SearchStudentEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
}
