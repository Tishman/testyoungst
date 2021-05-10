//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import NetworkService
import Utilities

let groupInfoReducer = Reducer<GroupInfoState, GroupInfoAction, GroupInfoEnvironment> { state, action, env in
    
    switch action {
    case .viewAppeared:
        return .init(value: .refreshList)
        
    case .refreshList:
        state.isLoading = true
        let request = Dictionary_GetGroupInfoRequest.with {
            $0.id = state.id.uuidString
        }
        return env.groupsService.getGroupInfo(request: request)
            .tryMap(GroupInfoLogic.mapItems)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(GroupInfoAction.updateItems)
    
    case let .updateItems(response):
        switch response {
        case let .success(result):
            state.words = result.wordsItems
            state.info = .item(result.groupItem)
            
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        state.isLoading = false
        
    case .removeAlertOpened:
        state.alert = .init(title: TextState(Localizable.shouldDeleteGroup),
                                  primaryButton: .destructive(TextState(Localizable.delete), send: .removeGroup),
                                  secondaryButton: .cancel(TextState(Localizable.cancel), send: .alertClosed))
        
    case .removeGroup:
        state.isLoading = true
        let request = Dictionary_RemoveGroupRequest.with {
            $0.groupID = state.id.uuidString
        }
        return env.groupsService.removeGroup(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(GroupInfoAction.removeGroupResult)
        
    case let .removeGroupResult(result):
        switch result {
        case .success:
            return .init(value: .closeSceneTriggered)
        case let .failure(error):
//            state.errorAlert = .init(title: TextState(error.description))
        break
        }
        state.isLoading = false
        
    case .alertClosed:
        state.alert = nil
        
    case .closeSceneTriggered, .editOpened:
        break
    }
    return .none
}

private struct GroupInfoLogic {
    
    
    static func mapItems(response: Dictionary_GetGroupInfoResponse) throws -> GroupInfoAction.UpdateItemsResult {
        let words = try DictionariesLogic.createWordsItems(words: response.words)
        let group = try DictGroupItem(id: .from(string: response.group.id),
                                      alias: response.group.alias,
                                      state: .init(title: response.group.name,
                                                   subtitle: Localizable.dWords(Int(response.group.wordCount))))
    
        return .init(groupItem: group,
                     wordsItems: words)
    }
    
    
}
