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

public struct TranslateState: Equatable {
    var sourceLanguage: Languages
    var destinationLanguage: Languages
    var value: String
    var translationResult: String
    var wasWordTranslated: Bool
    var wordList: [Word]
    
    public struct Word: Identifiable, Equatable {
        public var id: UUID = .init()
        var sourceText: String = ""
        var destinationText: String = ""
        
        public static func ==(lhs: Word, rhs: Word) -> Bool {
            return lhs.id == rhs.id && lhs.sourceText == rhs.sourceText && lhs.destinationText == rhs.destinationText
        }
    }
}

public extension TranslateState {
    init() {
        self.sourceLanguage = .english
        self.destinationLanguage = .russian
        self.value = Localizable.inputTranslationPlacholder
        self.translationResult = Localizable.outputTranslationPlacholder
        self.wasWordTranslated = false
        self.wordList = []
    }
}

public enum TranslateAction: Equatable {
    case translateButtonTapped
    case switchButtonTapped
    case outputTextChanged(String)
    case inputTextChanged(String)
    case didRecievTranslation(Result<Translator_TranslationResponse, EquatableError>)
    case addWordButtonTapped
    case clearButtonTapped
    case didSaveWord(TranslateState.Word)
    case didClearWords
}

public struct EquatableError: Error, Equatable {
    let value: Error
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
}


public struct TranslateEnviroment {
    let client: Translator_TranslatorClient
    
    public init(client: Translator_TranslatorClient) {
        self.client = client
    }
}

private struct TranslateLogic {
    
    static func addWordFabric(sourceLanguage: Languages,
                              destinationLanguage: Languages,
                              sourceText: String,
                              destinationText: String) -> TranslateState.Word? {
        var word = TranslateState.Word()
        switch (sourceLanguage, destinationLanguage) {
        case (.english, .russian):
            word.sourceText = sourceText
            word.destinationText = destinationText
            return word
            
        case (.russian, .english):
            word.sourceText = sourceText
            word.destinationText = destinationText
            return word
            
        default:
            return nil
        }
    }
}

public let translateReducer = Reducer<TranslateState, TranslateAction, TranslateEnviroment> { state, action, env in
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
            .map({ TranslateAction.didRecievTranslation($0) })
            
        
    case .outputTextChanged(let value):
        state.translationResult = value
        
    case .inputTextChanged(let value):
        state.value = value
        
    case .didRecievTranslation(let result):
        switch result {
        case .success(let response):
            state.translationResult = response.translations.first(where: { $0.value != "" })?.value ?? ""
            state.wasWordTranslated = true
            
        case .failure(let error):
            break
        }
        
    case .addWordButtonTapped:
        return .none
        
    case .clearButtonTapped:
        return .none
        
    case .didSaveWord(let word):
        state.wordList.append(word)
        state.wasWordTranslated = false
        
    case .didClearWords:
        state.wordList = []
        
    }
    return .none
}



