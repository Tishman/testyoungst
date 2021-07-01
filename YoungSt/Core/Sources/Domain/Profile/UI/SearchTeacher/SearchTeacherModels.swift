//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.06.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import NetworkService
import Coordinator

struct SearchTeacherState: Equatable, ClosableState {
    var searchText = ""
    var isSearchLoading = false
    var isInviteSendingLoading = false
    var isClosed = false
    
    var profileList: IdentifiedArrayOf<ProfileInfo> = []
    var alert: AlertState<SearchTeacherAction>?
}

enum SearchTeacherAction: Equatable {
    case searchTextChanged(String)
    case searchLoaded(Result<SearchStudentAction.SearchResult, EquatableError>)
    case inviteSended(Result<EmptyResponse, EquatableError>)
    case alertClosed
    case profile(id: UUID, action: ProfileAction)
    
    enum ProfileAction: Equatable {
        case selected
    }
}

struct SearchTeacherEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
}
