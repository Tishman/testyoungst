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
    Reducer { state, action, env in
        enum Cancellable: CaseIterable, Hashable {
            case addGroup
        }
        
        switch action {
        case let .titleChanged(newText):
            state.title = newText
            
            return .init(value: .titleErrorChanged(nil))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
            
        case let .titleErrorChanged(titleError):
            state.titleError = titleError
            
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
                return .init(value: .titleErrorChanged(Localizable.fillAllFields))
                    .receive(on: DispatchQueue.main.animation())
                    .eraseToEffect()
            }
            
            let request = Dictionary_AddGroupRequest.with {
                $0.name = state.title
                $0.items = state.items.map(\.item)
                $0.userID = state.userID.uuidString
            }
            state.isLoading = true
            return env.groupsService.addGroup(request: request)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(AddGroupAction.gotAddGroup)
                .cancellable(id: Cancellable.addGroup, bag: env.bag)
            
        case .alertClosePressed:
            state.alertError = nil
            
        case let .showAlert(error):
            state.alertError = .init(title: TextState(error))
            
        case let .addWordOpened(isOpened):
            state.addWordOpened = isOpened
            
        case let .wordAdded(request):
            let item = Dictionary_AddWordItem.with {
                $0.source = request.sourceText
                $0.destination = request.destinationText
            }
            state.items.append(.init(id: .init(), item: item))
            
        case .closeSceneTriggered:
            state.isClosed = true
            return .cancelAll(bag: env.bag)
        }
        
        return .none
    }
)
