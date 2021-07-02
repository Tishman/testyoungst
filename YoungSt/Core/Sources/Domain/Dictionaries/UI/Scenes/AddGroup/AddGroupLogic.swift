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
import Coordinator
import Protocols

let addGroupReducer = Reducer<AddGroupState, AddGroupAction, AddGroupEnvironment> { state, action, env in
    enum Cancellable: CaseIterable, Hashable {
        case addGroup
    }
    
    func groupModel() -> DictGroupModel? {
        guard !state.title.isEmpty else { return nil }
        return DictGroupModel(id: .init(), // we dont care about group cause it not exists yet
                              alias: state.title,
                              state: DictGroupInfo(title: state.title, subtitle: ""))
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
        
    case .addGroupTriggered:
        let title = state.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else {
            return .init(value: .titleErrorChanged(Localizable.fillAllFields))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
        }
        
        let request = Dictionary_AddGroupRequest.with {
            $0.name = title
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
        
    case .alertCloseTriggered:
        state.alertError = nil
        
    case let .showAlert(error):
        state.alertError = .init(title: TextState(error))
        
    case .route(.addWord):
        state.routing = .addWord(.init(word: nil, group: groupModel()))
        
    case let .route(.editWord(id)):
        guard let word = state.items[id: id] else { break }
        let groupModel = groupModel()
        let wordModel = DictWordModel(id: id,
                                      groupID: groupModel?.id ?? .init(),
                                      state: .init(text: word.item.source,
                                                   translation: word.item.destination,
                                                   info: word.item.description_p))
        
        let model = AddWordInput.InputModel(word: wordModel, group: groupModel)
        state.routing = .addWord(model)
        
    case .route(.handled):
        state.routing = nil
        
    case let .wordAdded(request):
        let addItem = Dictionary_AddWordItem.with {
            $0.source = request.sourceText
            $0.destination = request.translationText
            $0.description_p = request.destinationText
        }
        if var itemToEdit = state.items[id: request.id] {
            itemToEdit.item = addItem
            state.items[id: request.id] = itemToEdit
        } else {
            state.items.append(.init(id: request.id, item: addItem))
        }
        
    case let .wordAction(id, action: .selected):
        return .init(value: .route(.editWord(id)))
        
    case let .wordAction(id, action: .removed):
        state.items.remove(id: id)
        
    case .closeSceneTriggered:
        state.isClosed = true
        return .cancelAll(bag: env.bag)
    }
    
    return .none
}
.analytics()

