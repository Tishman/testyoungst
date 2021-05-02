//
//  File.swift
//  
//
//  Created by Nikita Patskov on 30.04.2021.
//

import Foundation
import ComposableArchitecture
import Combine
import Utilities
import NetworkService
import Resources

let addGroupReducer = Reducer<AddGroupState, AddGroupAction, AddGroupEnvironment>.combine(
    addWordReducer.optional().pullback(state: \.addWordState, action: /AddGroupAction.addWord, environment: \.addWordEnv),
    Reducer { state, action, env in
        switch action {
        case let .titleChanged(newText):
            state.title = newText
            
        case let .gotAddGroup(response):
            switch response {
            case .success:
                return .init(value: .closeSceneTriggered)
            case let .failure(error):
                state.alertError = .init(title: TextState(error.description))
            }
            state.isLoading = false
            
        case .addGroupPressed:
            guard !state.title.isEmpty else {
                return .init(value: .showAlert(Localizable.fillAllFields))
            }
            
            guard let userID = state.userID ?? env.userProvider.currentUserID else {
                return .init(value: .showAlert(Localizable.unknownError))
            }
            
            let request = Dictionary_AddGroupRequest.with {
                $0.name = state.title
                $0.items = state.items.map(\.item)
                $0.userID = userID.uuidString
            }
            state.isLoading = true
            return env.groupsService.addGroup(request: request)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(AddGroupAction.gotAddGroup)
            
        case .alertClosePressed:
            state.alertError = nil
            
        case let .showAlert(error):
            state.alertError = .init(title: TextState(error))
            
        case let .addWordOpened(isOpened):
            if isOpened {
                state.addWordState = .init(semantic: .addLater,
                                           sourceLanguage: env.languageProvider.sourceLanguage,
                                           destinationLanguage: env.languageProvider.destinationLanguage)
            } else {
                state.addWordState = nil
            }
            
        case let .addWord(.addLaterTriggered(item)):
            state.items.append(.init(id: .init(), item: item.item))
            state.addWordState = nil
            
        case .addWord(.closeSceneTriggered):
            state.addWordState = nil
            
        case .addWord, .closeSceneTriggered:
            break
        }
        
        return .none
    }
    
)