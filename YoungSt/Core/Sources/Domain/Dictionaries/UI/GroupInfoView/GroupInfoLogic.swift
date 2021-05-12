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
    
    enum Cancellable: Hashable {
        case getGroupInfo
        case removeGroup
        case getUserWords
        case deleteWord(UUID)
        case editGroup
    }
    
    switch action {
    case .viewAppeared:
        return .init(value: .refreshList)
        
    case .refreshList:
        state.isLoading = true
        let request = Dictionary_GetGroupInfoRequest.with {
            $0.id = state.id.uuidString
        }
        return env.groupsService.getGroupInfo(request: request)
            .tryMap { try GroupInfoLogic.mapItems(response: $0, deletingGroup: nil) }
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(GroupInfoAction.updateItems)
            .cancellable(id: Cancellable.getGroupInfo, bag: env.bag)
    
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
        
    case let .deleteWordRequested(item):
        state.alert = .init(title: TextState(Localizable.shouldDeleteGroup),
                            primaryButton: .destructive(TextState(Localizable.delete), send: .deleteWordAlertPressed(item)),
                            secondaryButton: .cancel(TextState(Localizable.cancel), send: .alertClosed))
        
    case let .deleteWordAlertPressed(item):
        return .init(value: .deleteWordTriggered(item))
            .receive(on: DispatchQueue.main.animation())
            .eraseToEffect()
        
    case let .deleteWordTriggered(item):
        state.deletingWords.insert(item.id)
        return env.wordsService.removeWord(request: item.id)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map { .wordDeleted(.init(deletingID: item.id, result: $0)) }
            .cancellable(id: Cancellable.deleteWord(item.id), bag: env.bag)
        
    case let .wordDeleted(response):
        switch response.result {
        case let .success(result):
            let request = Dictionary_GetGroupInfoRequest.with {
                $0.id = state.id.uuidString
            }
            return env.groupsService.getGroupInfo(request: request)
                .tryMap { try GroupInfoLogic.mapItems(response: $0, deletingGroup: response.deletingID) }
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(GroupInfoAction.updateItems)
                .cancellable(id: Cancellable.getGroupInfo, bag: env.bag)
                
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
            state.deletingWords.remove(response.deletingID)
        }
        
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
            .cancellable(id: Cancellable.removeGroup, bag: env.bag)
        
    case let .removeGroupResult(result):
        switch result {
        case .success:
            return .init(value: .closeSceneTriggered)
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        state.isLoading = false
        
    case .alertClosed:
        state.alert = nil
        
    case .closeSceneTriggered:
        return .cancelAll(bag: env.bag)
        
    case .editOpened:
        state.editState = .init(text: state.itemInfo?.state.title ?? "")
        
    case let .editTextChanged(editText):
        state.editState?.text = editText
        
    case .editCancelled:
        state.editState = nil
        
    case .editCommited:
        guard let name = state.editState?.text else { break }
        if name.isEmpty || name == state.itemInfo?.state.title {
            state.editState = nil
        } else {
            state.editState?.isLoading = true
            let request = Dictionary_EditGroupRequest.with {
                $0.id = state.id.uuidString
                $0.name = name
            }
            return env.groupsService.editGroup(request: request)
                .map(\.group)
                .tryMap(GroupInfoLogic.createGroupItem)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main.animation(GroupInfoScene.editAnimation))
                .catchToEffect()
                .map(GroupInfoAction.editFinished)
                .cancellable(id: Cancellable.editGroup, bag: env.bag)
        }
        
    case let .editFinished(result):
        switch result {
        case let .success(item):
            state.info = .item(item)
            state.editState = nil
            return .init(value: .refreshList)
            
        case let .failure(error):
            state.editState?.isLoading = false
            state.alert = .init(title: TextState(error.description))
        }
    }
    return .none
}

private struct GroupInfoLogic {
    
    static func mapItems(response: Dictionary_GetGroupInfoResponse, deletingGroup: UUID?) throws -> GroupInfoAction.UpdateItemsResult {
        let words = try DictionariesLogic.createWordsItems(words: response.words)
        let group = try createGroupItem(from: response.group)
    
        return .init(groupItem: group,
                     wordsItems: words,
                     deletingGroup: deletingGroup)
    }
    
    static func createGroupItem(from group: Dictionary_Group) throws -> DictGroupItem {
        try DictGroupItem(id: .from(string: group.id),
                                      alias: group.alias,
                                      state: .init(title: group.name,
                                                   subtitle: Localizable.dWords(Int(group.wordCount))))
    }
    
    
}
