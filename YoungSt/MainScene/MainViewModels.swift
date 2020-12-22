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
}

enum TranslateAction {
	case translateButtonTapped
	case switchButtonTapped
	case textChanged(String)
	case didReciev(Result<TranslationResponse, Error>)
}

struct TranslateEnviroment {
	let networkService: NetworkServiceProtocol = NetworkService()
}

private struct TranslateLogic {
	static func fetchTrans(networkService: NetworkServiceProtocol, requestModel: TranslationRequest) -> AnyPublisher<TranslationResponse, Error> {
		return networkService.sendDataRequest(url: "http://52.56.193.36/translate",
											  method: .post,
											  requestModel: requestModel)
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
			.catchToEffect()
			.map({ TranslateAction.didReciev($0) })
		
	case .textChanged(let value):
		state.value = value
		
	case .didReciev(let result):
		switch result {
		case .success(let response):
			state.translationResult = response.result
			
		case .failure(let error):
			break
		}
	}
	return .none
}


