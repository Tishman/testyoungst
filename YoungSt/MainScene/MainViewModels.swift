//
//  MainViewModels.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import Foundation
import Combine
import ComposableArchitecture

// MARK: - Translate

struct TranslateState: Equatable {
	var from: Languages = .english
	var to: Languages = .russian
	var value: String = ""
	var translationResult: String?
	var wasWordTranslated: Bool = false
	var wordList: [Word] = []
	
	struct Word: Identifiable, Equatable {
		var id: UUID = .init()
		var fromText: String = ""
		var toText: String = ""
		
		static func ==(lhs: Word, rhs: Word) -> Bool {
			return lhs.id == rhs.id && lhs.fromText == rhs.fromText && lhs.toText == rhs.toText
		}
	}
}

enum TranslateAction: Equatable {
	case translateButtonTapped
	case switchButtonTapped
	case textChanged(String)
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
	
	static func addWordFabric(from: Languages, to: Languages, fromText: String, toText: String) -> TranslateState.Word? {
		var word = TranslateState.Word()
		switch (from, to) {
		case (.english, .russian):
			word.fromText = fromText
			word.toText = toText
			return word
			
		case (.russian, .english):
			word.fromText = toText
			word.toText = fromText
			return word
			
		default:
			return nil
		}
	}
}

let translateReducer = Reducer<TranslateState, TranslateAction, TranslateEnviroment> { state, action, env in
	switch action {
	case .switchButtonTapped:
		let newFrom = state.to
		let newTo = state.from
		state.from = newFrom
		state.to = newTo
		
	case .translateButtonTapped:
		return TranslateLogic.fetchTrans(networkService: env.networkService, requestModel: TranslationRequest(state: state))
			.receive(on: DispatchQueue.main)
			.mapError(EquatableError.init)
			.catchToEffect()
			.map({ TranslateAction.didRecievTranslation($0) })
		
	case .textChanged(let value):
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
			  let toText = state.translationResult,
			  let word = TranslateLogic.addWordFabric(from: state.from,
													  to: state.to,
													  fromText: state.value,
													  toText: toText) else { return .none }
		
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



