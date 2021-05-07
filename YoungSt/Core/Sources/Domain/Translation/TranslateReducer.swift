//
//  TranslateViewModel.swift
//  YoungSt
//
//  Created by tichenko.r on 03.03.2021.
//

import Foundation
import Combine
import ComposableArchitecture
import Resources
import NetworkService
import Utilities

let translateReducer = Reducer<TranslateState, TranslateAction, TranslateEnviroment> { state, action, env in
    switch action {
    case .switchButtonTapped:
        let newSource = state.destinationLanguage
        let newDestination = state.sourceLanguage
        state.sourceLanguage = newSource
        state.destinationLanguage = newDestination
        
    case .translateButtonTapped:
        let requestData = Translator_TranslationRequest.with({
            $0.value = state.value
            $0.destinationLang = state.destinationLanguage.rawValue
            $0.sourceLang = state.sourceLanguage.rawValue
        })
        let translate = env.client.translate(requestData)
        return translate
            .response
            .publisher
            .receive(on: DispatchQueue.main)
            .mapError(EquatableError.init)
            .catchToEffect()
            .map(TranslateAction.didRecievTranslation)
            
        
    case .outputTextChanged(let value):
        state.translationResult = value
        
    case .inputTextChanged(let value):
        state.value = value
        
    case .didRecievTranslation(let result):
        switch result {
        case .success(let response):
            state.translationResult = response.translations.first(where: { $0.value != "" })?.value ?? ""
            
        case .failure(let error):
            break
        }
        
    case .addWordButtonTapped:
        break
        
    case .clearButtonTapped:
        break
        
    case .didSaveWord:
        break
        
    case .didClearWords:
        break
        
    }
    return .none
}



