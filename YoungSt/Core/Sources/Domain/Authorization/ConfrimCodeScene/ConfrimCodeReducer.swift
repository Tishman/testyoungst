//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources

let confrimCodeReducer = Reducer<ConfrimCodeState, ConfrimCodeAction, ConfrimCodeEnviroment> { state, action, enviroment in
	switch action {
	case let .failedValidation(value):
		state.alertMessage = value
		state.isAlertPresent = true
		
	case .alertPresented:
		state.alertMessage = ""
		state.isAlertPresent = false
		guard state.isCodeVerified else { break }
		return .init(value: .finishRegistartion)
	
	case let .handleConfrimation(.success(value)):
		state.isCodeVerified = value
		state.alertMessage = Localizable.accountCreated
		state.isAlertPresent = true
		
	case let .handleConfrimation(.failure(value)):
		state.isAlertPresent = true
		state.alertMessage = value.localizedDescription
		
	case let .didCodeStartEnter(value):
		state.code = value
		
	case .didConfrimButtonTapped:
		guard let service = enviroment.authorizationService else { return .none }
		guard !state.code.isEmpty && !state.userId.isEmpty else { return .init(value: .failedValidation(Localizable.fillAllFields)) }
		let requestData = Authorization_ConfirmCodeRequest.with {
			$0.code = state.code
			$0.userID = state.userId
		}
		
		return service.confirmCode(request: requestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ConfrimCodeAction.handleConfrimation)
		
	case .finishRegistartion:
		break
	}
	return .none
}
