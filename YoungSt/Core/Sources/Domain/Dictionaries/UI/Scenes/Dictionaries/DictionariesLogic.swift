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
    Reducer { state, action, env in
        enum Cancellable: Hashable {
            case getUserLists
            case getUserWords
            case dictObserving
            case deleteWord(UUID)
            case showLoader
        }
        
        switch action {
        case .refreshTriggered:
            return .init(value: .updateItems)
            
        case .viewLoaded:
            let dictChangedPublisher = env.dictionaryEventPublisher.publisher
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
                .map { _ in DictionariesAction.silentUpdateItems }
                .cancellable(id: Cancellable.dictObserving, bag: env.bag)
            
            return .merge(
                .init(value: .updateItems),
                dictChangedPublisher
            )
            
        case .alertCloseTriggered:
            state.alert = nil
            
        case let .deleteWordTriggered(id):
            state.alert = .init(title: TextState(Localizable.shouldDeleteWord),
                                primaryButton: .destructive(TextState(Localizable.delete), send: .deleteWordAlertTriggered(id)),
                                secondaryButton: .cancel(TextState(Localizable.cancel), send: .alertCloseTriggered))
        
        case .updateItems:
            return .merge(
                .init(value: .silentUpdateItems),
                Effect(value: .showLoader(true))
                    .delay(for: .milliseconds(700), scheduler: RunLoop.main)
                    .eraseToEffect()
                    .cancellable(id: Cancellable.showLoader, cancelInFlight: true, bag: env.bag)
                )
            
        case .silentUpdateItems:
            let wordsRequest = Dictionary_GetUserWordsRequest.with {
                $0.userID = state.userID.uuidString
                $0.groupID = ""
            }
            let groupsRequest = Dictionary_GetUserGroupsRequest.with {
                $0.userID = state.userID.uuidString
                $0.order = .position
            }
            
            return env.wordsService.getUserWords(request: wordsRequest)
                .combineLatest(env.groupsService.getUserGroups(request: groupsRequest))
                .tryMap(DictionariesLogic.createUpdateItemsResult)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main.animation())
                .catchToEffect()
                .map(DictionariesAction.itemsUpdated)
                .cancellable(id: Cancellable.getUserLists, bag: env.bag)
            
        case let .itemsUpdated(response):
            switch response {
            case let .success(result):
                state.words = result.words
                state.groups = result.groups
                state.lastUpdate = env.timeFormatter.string(from: Date())
                
            case let .failure(error):
                state.alert = .init(title: TextState(error.description))
            }
            
            return Effect(value: .showLoader(false))
                .cancellable(id: Cancellable.showLoader, cancelInFlight: true, bag: env.bag)
            
        case let .showLoader(isLoading):
            state.isLoading = isLoading
            
        case let .showAlert(errorText):
            state.alert = .init(title: TextState(errorText))
            
        case let .deleteWordAlertTriggered(id):
            return .init(value: .deleteWordSubmitted(id))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
            
        case let .deleteWordSubmitted(id):
            state.deletingWords.insert(id)
            return env.wordsService.removeWord(request: id)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map { .wordDeleted(.init(deletingID: id, result: $0)) }
                .cancellable(id: Cancellable.deleteWord(id), bag: env.bag)
            
        case let .wordDeleted(response):
            switch response.result {
            case let .success(result):
                let request = Dictionary_GetUserWordsRequest.with {
                    $0.userID = state.userID.uuidString
                    $0.groupID = ""
                }
                return env.wordsService.getUserWords(request: request)
                    .map(\.items)
                    .tryMap(DictionariesLogic.createWordsItems)
                    .mapError(EquatableError.init)
                    .receive(on: DispatchQueue.main)
                    .catchToEffect()
                    .map {
                        DictionariesAction.wordsUpdated(.init(result: $0, removedID: response.deletingID))
                    }
                    .cancellable(id: Cancellable.getUserWords, bag: env.bag)
                    
            case let .failure(error):
                state.alert = .init(title: TextState(error.description))
                state.deletingWords.remove(response.deletingID)
            }
            
        case let .wordsUpdated(response):
            switch response.result {
            case let .success(items):
                state.words = items
                if let removedID = response.removedID {
                    state.deletingWords.remove(removedID)
                }
            case let .failure(error):
                break
            }
            
        case let .route(.word(id)):
            guard let item = state.words.first(where: { $0.id == id }) else { break }
            let group = state.groups.first(where: { $0.id == item.groupID })
            state.routing = .addWord(
                .init(semantic: .addToServer,
                      userID: state.userID,
                      groupSelectionEnabled: true,
                      model: .init(word: item, group: group))
            )
            
        case let .route(.group(id)):
            guard let groupItem = state.groups.first(where: { $0.id == id })
            else { break }
            state.routing = .groupInfo(userID: state.userID, info: .item(groupItem))
            
        case .route(.addGroup):
            state.routing = .addGroup(userID: state.userID)
            
        case .route(.handled):
            state.routing = nil
            
        case .route(.addWord):
            state.routing = .addWord(
                .init(semantic: .addToServer,
                      userID: state.userID,
                      groupSelectionEnabled: true)
            )
        }
        return .none
    }
    .analytics()
)

struct DictionariesLogic {
    
    static func createGroupsItems(groups: [Dictionary_Group]) throws -> [DictGroupItem] {
        try groups.map {
            try DictGroupItem(id: .from(string: $0.id),
                              alias: $0.alias.isEmpty ? nil : $0.alias,
                              state: .init(title: $0.name,
                                           subtitle: Localizable.dWords(Int($0.wordCount))))
        }
    }
    
    static func createWordsItems(words: [Dictionary_DictionaryItem]) throws -> [DictWordItem] {
        try words.map {
            try DictWordItem(id: .from(string: $0.id),
                             groupID: .from(string: $0.groupID),
                             state: .init(text: $0.source,
                                          translation: $0.destination,
                                          info: $0.description_p))
        }
    }
    
    static func createUpdateItemsResult(words: Dictionary_GetUserWordsResponse, groups: Dictionary_GetUserGroupsResponse) throws -> DictionariesAction.UpdateItemsResult {
        return try .init(groups: createGroupsItems(groups: groups.groups),
                         words: createWordsItems(words: words.items))
    }
    
}
