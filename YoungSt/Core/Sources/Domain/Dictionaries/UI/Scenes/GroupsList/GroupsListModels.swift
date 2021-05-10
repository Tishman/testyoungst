//
//  File.swift
//  
//
//  Created by Nikita Patskov on 09.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities

struct GroupsListState: Equatable, Previwable {
    let userID: UUID
    
    var groups: [DictGroupItem] = []
    var isLoading = false
    var alertError: AlertState<GroupsListAction>?
    
    
    static var preview: GroupsListState = .init(userID: .init(),
                                                groups: [DictGroupItem.preview, .init(id: .init(), alias: nil, state: .preview)])
}

enum GroupsListAction: Equatable {
    case viewAppeared
    case listRefreshRequested
    case groupsUpdated(Result<[DictGroupItem], EquatableError>)
    case groupSelected(DictGroupItem)
    
    case closeSceneTriggered
}

struct GroupsListEnvironment {
    let groupsService: GroupsService
}
