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

let confrimEmailReducer = Reducer<ConfrimEmailState, ConfrimEmailAction, ConfrimEmailEnviroment> { state, action, enviroment in
	switch action {
    case let .codeInputFocusChanged(isFocused):
        state.codeFieldForceFocused = isFocused
    
	case let .failedValidation(value):
		state.alert = .init(title: TextState(value),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
	
	case let .handleConfrimation(.success(value)):
		state.isCodeVerified = value
		state.alert = .init(title: TextState(Localizable.accountCreated),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case let .handleConfrimation(.failure(value)):
		state.alert = .init(title: TextState(value.localizedDescription),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
		
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
			.map(ConfrimEmailAction.handleConfrimation)
		
	case .alertOkButtonTapped:
		state.alert = nil
		if state.isCodeVerified {
			state.isClosed = true
		}
	}
	return .none
}
