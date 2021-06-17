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
    Reducer { state, action, env in
        
        enum Cancellable: CaseIterable, Hashable {
            case translate
            case editWord
            case addWord
            case initTranslationRequest
        }
        
        switch action {
        case .viewAppeared:
            if !state.editingMode && state.isBootstrapping {
                state.sourceFieldForceFocused = true
            }
            state.isBootstrapping = false
            
        case let .sourceInputFocusChanged(isForceFocused):
            state.sourceFieldForceFocused = isForceFocused
            
        case let .sourceChanged(source):
            state.sourceText = source
            state.isTranslateLoading = true
            
            let errorChangedEffect = Effect<AddWordAction, Never>(value: .sourceErrorChanged(nil))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
            
            let translateRequestInitedEffect = Effect<AddWordAction, Never>(value: .translatePressed)
                .delay(for: .seconds(source.isEmpty ? 0 : 1), scheduler: RunLoop.main)
                .eraseToEffect()
                .cancellable(id: Cancellable.initTranslationRequest, cancelInFlight: true, bag: env.bag)
            
            return .merge(errorChangedEffect, translateRequestInitedEffect)
            
        case let .sourceErrorChanged(sourceError):
            state.sourceError = sourceError
            
        case let .translationChanged(translation):
            state.translationText = translation
            
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
            if state.isAddPending {
                state.isAddPending = false
                return .init(value: .addPressed)
            }
            
        case .alertClosePressed:
            state.alertError = nil
            
        case .swapLanguagesPressed:
            swap(&state.sourceText, &state.translationText)
            state.leftToRight.toggle()
            return .init(value: .sourceErrorChanged(nil))
                .receive(on: DispatchQueue.main.animation())
                .eraseToEffect()
            
        case let .translationDownloaded(result):
            state.localTranslationDownloading = false
            
        case .translatePressed:
            state.isTranslateLoading = true
            
            return .merge(
                env.translationService.translate(text: state.sourceText, from: state.currentSource, to: state.currentDestination)
                    .mapError(EquatableError.init)
                    .receive(on: DispatchQueue.main)
                    .catchToEffect()
                    .map(AddWordAction.gotTranslation)
                    .cancellable(id: Cancellable.translate, cancelInFlight: true, bag: env.bag),
                .cancel(id: Cancellable.initTranslationRequest, bag: env.bag)
            )
            
        case .auditionPressed:
            let text = state.translationText
            let language = state.currentDestination
            return Effect.fireAndForget {
                env.auditionService.speak(text: text, language: language)
            }
            
        case .addPressed:
            var source = state.sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
            if source.isEmpty {
                return .init(value: .sourceErrorChanged(Localizable.youShouldTypeText))
                    .receive(on: DispatchQueue.main.animation())
                    .eraseToEffect()
            }
            
            state.isLoading = true
            if state.isTranslateLoading {
                state.isAddPending = true
                break
            }
            
            switch state.info.semantic {
            case .addToServer:
                var destination = state.translationText
                if !state.leftToRight {
                    swap(&source, &destination)
                }
                
                if let editingWordID = state.info.editingWordID {
                    let request = Dictionary_EditWordRequest.with {
                        $0.id = editingWordID.uuidString
                        $0.userID = state.info.userID.uuidString
                        $0.source = source
                        $0.destination = destination
                        $0.description_p = state.descriptionText
                        if let groupId = state.selectedGroup?.id.uuidString {
                            $0.addDestination = .toGroupID(groupId)
                        } else {
                            $0.addDestination = .toRootGroupOfUser(state.info.userID.uuidString)
                        }
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
                        if let groupId = state.selectedGroup?.id.uuidString {
                            $0.addDestination = .toGroupID(groupId)
                        } else {
                            $0.addDestination = .toRootGroupOfUser(state.info.userID.uuidString)
                        }
                        $0.item = .with {
                            $0.source = source
                            $0.destination = destination
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
                handler.value(.init(id: state.info.editingWordID ?? .init(),
                                    sourceText: source,
                                    translationText: state.translationText,
                                    destinationText: state.descriptionText))
                return .merge(.cancelAll(bag: env.bag), Effect(value: .closeSceneTriggered))
            }
            
        case .groupsOpened:
            state.routing = .groupsList(userID: state.info.userID)
            
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
            state.isClosed = true
            
        case .routingHandled:
            state.routing = nil
            
        case let .selectedGroupChanged(item):
            state.selectedGroup = item.map { .init(id: $0.id, title: $0.state.title) }
        }
        
        return .none
    }
    
)
