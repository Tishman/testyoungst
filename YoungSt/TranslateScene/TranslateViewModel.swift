//
//  TranslateViewModel.swift
//  YoungSt
//
//  Created by tichenko.r on 03.03.2021.
//

import Foundation
import Combine
import ComposableArchitecture

struct TranslateState: Equatable {
    var sourceLanguage: Languages = .english
    var destinationLanguage: Languages = .russian
    var value: String = "Enter word"
    var translationResult: String = "Result here"
    var wasWordTranslated: Bool = false
    var wordList: [Word] = []
    
    struct Word: Identifiable, Equatable {
        var id: UUID = .init()
        var sourceText: String = ""
        var destinationText: String = ""
        
        static func ==(lhs: Word, rhs: Word) -> Bool {
            return lhs.id == rhs.id && lhs.sourceText == rhs.sourceText && lhs.destinationText == rhs.destinationText
        }
    }
}

enum TranslateAction: Equatable {
    case translateButtonTapped
    case switchButtonTapped
    case outputTextChanged(String)
    case inputTextChanged(String)
    case didRecievTranslation(Result<TranslationResponse, EquatableError>)
    case addWordButtonTapped
    case clearButtonTapped
    case didSaveWord(TranslateState.Word)
    case didClearWords
}

struct EquatableError: Error, Equatable {
    let value: Error
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
}


struct TranslateEnviroment {
    let networkService: NetworkServiceProtocol
    let databaseService: DatabaseServiceProtocol
}

private struct TranslateLogic {
    static func fetchTrans(networkService: NetworkServiceProtocol, requestModel: TranslationRequest) -> AnyPublisher<TranslationResponse, Error> {
        return networkService.sendDataRequest(url: "http://52.56.193.36/translate",
                                              method: .post,
                                              requestModel: requestModel)
    }
    
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

let translateReducer = Reducer<TranslateState, TranslateAction, TranslateEnviroment> { state, action, env in
    switch action {
    case .switchButtonTapped:
        let newSource = state.destinationLanguage
        let newDestination = state.sourceLanguage
        state.sourceLanguage = newSource
        state.destinationLanguage = newDestination
        
    case .translateButtonTapped:
        return TranslateLogic.fetchTrans(networkService: env.networkService, requestModel: TranslationRequest(state: state))
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
            state.translationResult = response.result
            state.wasWordTranslated = true
            
        case .failure(let error):
            break
        }
        
    case .addWordButtonTapped:
        guard state.wasWordTranslated,
              !state.value.isEmpty,
              let word = TranslateLogic.addWordFabric(sourceLanguage: state.sourceLanguage,
                                                      destinationLanguage: state.destinationLanguage,
                                                      sourceText: state.value,
                                                      destinationText: state.translationResult) else { return .none }
        
        return env.databaseService.save(WordDBModel(viewModel: word))
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map({ _ in TranslateAction.didSaveWord(word) })
        
    case .clearButtonTapped:
        guard !state.wordList.isEmpty else { return .none }
        return env.databaseService.deleteAll(WordDBModel.self)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map({ _ in TranslateAction.didClearWords })
        
    case .didSaveWord(let word):
        state.wordList.append(word)
        state.wasWordTranslated = false
        
    case .didClearWords:
        state.wordList = []
        
    }
    return .none
}



