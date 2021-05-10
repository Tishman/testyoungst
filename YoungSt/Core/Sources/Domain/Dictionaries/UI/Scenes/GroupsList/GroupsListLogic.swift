//
//  File.swift
//  
//
//  Created by Nikita Patskov on 09.05.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Utilities

let groupsListReducer = Reducer<GroupsListState, GroupsListAction, GroupsListEnvironment> { state, action, env in
    switch action {
    case .viewAppeared:
        return .init(value: .listRefreshRequested)
    case .listRefreshRequested:
        struct RefreshListCancellable: Hashable {}
        
        state.isLoading = true
        let request = Dictionary_GetUserGroupsRequest.with {
            $0.userID = state.userID.uuidString
            $0.order = .lastUsage
        }
        return env.groupsService.getUserGroups(request: request)
            .map(\.groups)
            .tryMap(DictionariesLogic.createGroupsItems)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(GroupsListAction.groupsUpdated)
            .cancellable(id: RefreshListCancellable())
        
    case let .groupsUpdated(response):
        state.isLoading = false
        switch response {
        case let .success(items):
            state.groups = items
        case let .failure(error):
            state.alertError = .init(title: TextState(error.description))
        }
        
    case .groupSelected, .closeSceneTriggered:
        break
    }
    return .none
}
