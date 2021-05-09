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
    groupsListReducer.optional().pullback(state: \.groupsListState, action: /AddWordAction.groupsList, environment: \.groupsListEnv),
    Reducer { state, action, env in
       switch action {
       case .viewAppeared:
           break
       
       case let .sourceChanged(source):
           state.sourceText = source
           
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
               .cancellable(id: TranslationID())
           
       case .addPressed:
           if state.sourceText.isEmpty {
               state.alertError = .init(title: TextState(Localizable.youShouldTypeText))
               break
           }
           
           let request = Dictionary_AddWordRequest.with {
               $0.groupID = state.selectedGroupID?.uuidString ?? ""
               $0.item = .with {
                   $0.source = state.sourceText
                   $0.destination = state.translationText
                   $0.description_p = state.descriptionText
               }
           }
           
           switch state.input.semantic {
           case .addToServer:
               state.isLoading = true
               return env.wordService.addWord(request: request)
                   .mapError(EquatableError.init)
                   .receive(on: DispatchQueue.main)
                   .catchToEffect()
                   .map(AddWordAction.gotWordAddition)
               
           case let .addLater(handler):
               handler(.init(sourceText: state.sourceText,
                             translationText: state.translationText,
                             destinationText: state.descriptionText))
               return .init(value: .closeSceneTriggered)
           }
           
       case let .groupsOpened(isOpened):
           if isOpened {
               state.groupsListState = .init(userID: state.input.userID)
           } else {
               state.groupsListState = nil
           }
           
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
           
       case .closeSceneTriggered:
           state.input.closeHandler()
           
       case let .groupsList(.groupSelected(selectedGroupID)):
           state.selectedGroupID = selectedGroupID
           state.groupsListState = nil
        
       case .groupsList(.closeSceneTriggered):
           state.groupsListState = nil
           
       case .groupsList:
           break
       }
       
       return .none
   }

)
