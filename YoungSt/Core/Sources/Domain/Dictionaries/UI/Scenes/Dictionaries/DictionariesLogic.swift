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
    addWordReducer.optional().pullback(state: \.addWordState, action: /DictionariesAction.addWord, environment: \.addWordEnv),
    addGroupReducer.optional().pullback(state: \.addGroupState, action: /DictionariesAction.addGroup, environment: \.addGroupEnv),
    Reducer { state, action, env in
        switch action {
        case .addGroup(.closeScene):
            state.addGroupState = nil
            return Effect(value: .silentRefreshList)
        
        case .addWord(.closeSceneTriggered):
            state.addWordState = nil
            return Effect(value: .silentRefreshList)
            
        case .addWord, .addGroup:
            break
        
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
            return .init(value: .refreshList)
            
        case let .itemsUpdated(response):
            switch response {
            case let .success(result):
                state.groups = result.groups
                state.words = result.words
            case let .failure(error):
                state.errorAlert = .init(title: TextState(error.description))
            }
            state.isLoading = false
            
        case .alertClosed:
            state.errorAlert = nil
            
        case let .showAlert(errorText):
            state.errorAlert = .init(title: TextState(errorText))
            
        case let .addWordOpened(isOpened):
            if isOpened {
                state.addWordState = .init(semantic: .addToServer,
                                           sourceLanguage: .russian,
                                           destinationLanguage: .english)
            } else {
                state.addWordState = nil
            }
        case let .addGroupOpened(isOpened):
            if isOpened {
                state.addGroupState = .init(userID: nil)
            } else {
                state.addGroupState = nil
            }
        }
        return .none
    }
    .debug()
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
                                           subtitle: "12 words"))
        }
        
        return .init(groups: groups,
                     words: words)
    }
    
}
