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

let addWordReducer = Reducer<AddWordState, AddWordAction, AddWordEnvironment> { state, action, env in
    switch action {
    case let .sourceChanged(source):
        state.sourceText = source
        
    case let .descriptionChanged(description):
        state.descriptionText = description
        
    case let .gotTranslation(result):
        switch result {
        case let .success(translation):
            state.descriptionText = translation
        case let .failure(error):
            state.alertError = .init(title: TextState(error.localizedDescription))
        }
        state.isTranslateLoading = false
        
    case .alertClosePressed:
        state.alertError = nil
        
    case .swapLanguagesPressed:
        state.leftToRight.toggle()
        
    case .translatePressed:
        state.isTranslateLoading = true
        
        let request = Translator_TranslationRequest.with {
            $0.value = state.sourceText
            $0.destinationLang = state.sourceLanguage.rawValue
            $0.sourceLang = state.sourceLanguage.rawValue
        }
        return env.translateService.translate(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(AddWordAction.gotTranslation)
        
    case .addPressed:
        if state.sourceText.isEmpty {
            state.alertError = .init(title: TextState(Localizable.youShouldTypeText))
            break
        }
        
        let request = Dictionary_AddWordRequest.with {
            $0.groupID = state.selectedGroupID?.uuidString ?? ""
            $0.item = .with {
                $0.source = state.sourceText
                $0.destination = state.descriptionText
            }
        }
        
        switch state.semantic {
        case .addToServer:
            state.isLoading = true
            return env.wordService.addWord(request: request)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(AddWordAction.gotWordAddition)
            
        case .addLater:
            return .init(value: .addLaterTriggered(request))
        }
        
    case let .groupsOpened(opened):
        state.groupsOpened = opened
        
    case let .selectedGroupChanged(groupID):
        state.selectedGroupID = groupID
        
    case let .gotWordAddition(result):
        switch result {
        case .success:
            return Effect(value: .closeSceneTriggered)
        case let .failure(error):
            state.alertError = .init(title: TextState(error.localizedDescription))
        }
        state.isLoading = false
        
    case .closeSceneTriggered, .addLaterTriggered:
        switch state.semantic {
        case let .addToServer(customCloseHandler) where customCloseHandler != nil:
            customCloseHandler!()
        default:
            break
        }
        break
    }
    
    return .none
}
