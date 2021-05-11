//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Utilities
import Resources

let addWordReducer = Reducer<AddWordState, AddWordAction, AddWordEnvironment>.combine(
    groupsListReducer
        .optional(bag: \.bag)
        .pullback(state: \.groupsListState, action: /AddWordAction.groupsList, environment: \.groupsListEnv),
    
    Reducer { state, action, env in
        
        enum Cancellable: CaseIterable, Hashable {
            case translate
            case editWord
            case addWord
        }
        
        switch action {
        case .viewAppeared:
            break
            
        case let .sourceChanged(source):
            state.sourceText = source
            return .init(value: .sourceErrorChanged(nil))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
            
        case let .sourceErrorChanged(sourceError):
            state.sourceError = sourceError
            
        case let .descriptionChanged(description):
            state.descriptionText = description
            
        case let .gotTranslation(result):
            switch result {
            case let .success(translation):
                state.translationText = translation
            case let .failure(error):
                state.alertError = .init(title: TextState(error.localizedDescription))
            }
            state.isTranslateLoading = false
            
        case .alertClosePressed:
            state.alertError = nil
            
        case .swapLanguagesPressed:
            state.leftToRight.toggle()
            
        case let .translationDownloaded(result):
            state.localTranslationDownloading = false
            
        case .translatePressed:
            struct TranslationID: Hashable {}
            
            state.isTranslateLoading = true
            return env.translationService.translate(text: state.sourceText, from: state.sourceLanguage, to: state.destinationLanguage)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(AddWordAction.gotTranslation)
                .cancellable(id: Cancellable.translate, bag: env.bag)
            
        case .addPressed:
            if state.sourceText.isEmpty {
                return .init(value: .sourceErrorChanged(Localizable.youShouldTypeText))
                    .receive(on: DispatchQueue.main.animation())
                    .eraseToEffect()
            }
            
            switch state.info.semantic {
            case .addToServer:
                state.isLoading = true
                
                if let editingWordID = state.info.editingWordID {
                    let request = Dictionary_EditWordRequest.with {
                        $0.id = editingWordID.uuidString
                        $0.userID = state.info.userID.uuidString
                        $0.source = state.sourceText
                        $0.destination = state.translationText
                        $0.description_p = state.descriptionText
                        $0.groupID = state.selectedGroup?.id.uuidString ?? ""
                    }
                    return env.wordService.editWord(request: request)
                        .mapError(EquatableError.init)
                        .map(toEmpty)
                        .receive(on: DispatchQueue.main)
                        .catchToEffect()
                        .map(AddWordAction.gotWordAddition)
                        .cancellable(id: Cancellable.editWord, bag: env.bag)
                    
                } else {
                    
                    let request = Dictionary_AddWordRequest.with {
                        $0.groupID = state.selectedGroup?.id.uuidString ?? ""
                        $0.item = .with {
                            $0.source = state.sourceText
                            $0.destination = state.translationText
                            $0.description_p = state.descriptionText
                        }
                    }
                    return env.wordService.addWord(request: request)
                        .mapError(EquatableError.init)
                        .receive(on: DispatchQueue.main)
                        .catchToEffect()
                        .map(AddWordAction.gotWordAddition)
                        .cancellable(id: Cancellable.addWord, bag: env.bag)
                }
                
                
            case let .addLater(handler):
                handler(.init(sourceText: state.sourceText,
                              translationText: state.translationText,
                              destinationText: state.descriptionText))
                return .concatenate(.cancelAll(bag: env.bag), Effect(value: .closeSceneTriggered))
            }
            
        case let .groupsOpened(isOpened):
            if isOpened {
                state.groupsListState = .init(userID: state.info.userID)
            } else {
                state.groupsListState = nil
            }
            
        case .removeSelectedGroupPressed:
            state.selectedGroup = nil
            
        case let .gotWordAddition(result):
            switch result {
            case .success:
                return .concatenate(.cancelAll(bag: env.bag), Effect(value: .closeSceneTriggered))
            case let .failure(error):
                state.alertError = .init(title: TextState(error.localizedDescription))
            }
            state.isLoading = false
            
        case .closeSceneTriggered:
            state.info.closeHandler()
            
        case let .groupsList(.groupSelected(selectedGroup)):
            state.selectedGroup = .init(id: selectedGroup.id,
                                        title: selectedGroup.state.title)
            state.groupsListState = nil
            
        case .groupsList(.closeSceneTriggered):
            state.groupsListState = nil
            
        case .groupsList:
            break
        }
        
        return .none
    }
    
)
