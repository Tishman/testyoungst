//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources
import Utilities
import Protocols

let dictionariesReducer = Reducer<DictionariesState, DictionariesAction, DictionariesEnvironment>.combine(
    addGroupReducer.optional().pullback(state: \.addGroupState, action: /DictionariesAction.addGroup, environment: \.addGroupEnv),
    groupInfoReducer.optional().pullback(state: \.groupInfoState, action: /DictionariesAction.groupInfo, environment: \.groupInfoEnv),
    Reducer { state, action, env in
        switch action {
        case .addGroup(.closeSceneTriggered):
            state.addGroupState = nil
            return Effect(value: .silentRefreshList)
            
        case .groupInfo(.closeSceneTriggered):
            state.groupInfoState = nil
            return Effect(value: .silentRefreshList)
        
        case .refreshList:
            state.isLoading = true
            return .init(value: .silentRefreshList)
            
        case .silentRefreshList:
            guard let userID = state.userID ?? env.userProvider.currentUserID else {
                return .init(value: .showAlert(Localizable.unknownError))
            }
            let wordsRequest = Dictionary_GetUserWordsRequest.with {
                $0.userID = userID.uuidString
                $0.groupID = ""
            }
            let groupsRequest = Dictionary_GetUserGroupsRequest.with {
                $0.userID = userID.uuidString
            }
            
            return env.wordsService.getUserWords(request: wordsRequest)
                .combineLatest(env.groupsService.getUserGroups(request: groupsRequest))
                .tryMap(DictionariesLogic.createUpdateItemsResult)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(DictionariesAction.itemsUpdated)
            
        case .viewLoaded:
            
            // TODO: Cancel Cancellable on view dismissing!
            struct CancelID: Hashable {}
            let dictChangedPublisher = env.dictionaryEventPublisher.dictionaryEventPublisher
                .eraseToEffect()
                .map { _ in DictionariesAction.silentRefreshList }
                .cancellable(id: CancelID())
            
            return .merge(
                .init(value: .refreshList),
                dictChangedPublisher
            )
            
        case let .itemsUpdated(response):
            switch response {
            case let .success(result):
                state.words = result.words
                state.lastUpdate = env.timeFormatter.string(from: Date())
                
                // rootGroupIndex should be 0, but we double check here :D
                if let rootGroupIndex = result.groups.firstIndex(where: { $0.alias == DictGroupItem.rootAlias }) {
                    state.rootGroupId = result.groups[rootGroupIndex].id
                    
                    var groups = result.groups
                    groups.remove(at: rootGroupIndex)
                    state.groups = groups
                    
                } else {
                    state.groups = result.groups
                }
                
            case let .failure(error):
                state.errorAlert = .init(title: TextState(error.description))
            }
            state.isLoading = false
            
        case .alertClosed:
            state.errorAlert = nil
            
        case let .showAlert(errorText):
            state.errorAlert = .init(title: TextState(errorText))
            
        case let .addWordOpened(isOpened):
            state.addWordOpened = isOpened
            
        case let .addGroupOpened(isOpened):
            if isOpened {
                state.addGroupState = .init(userID: nil)
            } else {
                state.addGroupState = nil
            }
        case let .openGroup(groupId):
            if let groupId = groupId, let groupItem = state.groups.first(where: { $0.id == groupId }) {
                state.groupInfoState = .init(info: .item(groupItem))
            } else {
                state.groupInfoState = nil
            }
        case .addGroup, .groupInfo:
            break
        }
        return .none
    }
)

private struct DictionariesLogic {
    
    static func createUpdateItemsResult(words: Dictionary_GetUserWordsResponse, groups: Dictionary_GetUserGroupsResponse) throws -> DictionariesAction.UpdateItemsResult {
        let words = try words.items.map {
            try DictWordItem(id: .from(string: $0.id),
                             state: .init(text: $0.source,
                                          info: $0.destination))
        }
        let groups = try groups.groups.map {
            try DictGroupItem(id: .from(string: $0.id),
                              alias: $0.alias.isEmpty ? nil : $0.alias,
                              state: .init(title: $0.name,
                                           subtitle: Localizable.dWords(Int($0.wordCount))))
        }
        
        return .init(groups: groups,
                     words: words)
    }
    
}
