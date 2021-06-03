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
	case let .failedValidation(value):
		state.alert = .init(title: TextState(value),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
	
	case let .handleConfrimation(.success(value)):
		state.isCodeVerified = value
		guard let service = enviroment.authorizationService else {
			state.isLoading = false
			break
		}
		guard value else {
			state.isLoading = false
			state.alert = .init(title: TextState(Localizable.incorrectCode),
								message: nil,
								dismissButton: .cancel(TextState(Localizable.ok)))
			break
		}
		
		let loginRequestData = Authorization_LoginRequest.with {
			$0.email = state.credentails.email
			$0.password = state.credentails.passsword
		}
		
		return service.login(request: loginRequestData)
			.receive(on: DispatchQueue.main)
			.catchToEffect()
			.map(ConfrimEmailAction.handleLogin)
		
	case .handleLogin(.success):
		state.isLoading = false
		
	case let .handleLogin(.failure(error)):
		state.isLoading = false
		state.alert = .init(title: TextState(error.localizedDescription),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case let .handleConfrimation(.failure(error)):
		state.isLoading = false
		state.alert = .init(title: TextState(error.localizedDescription),
							message: nil,
							dismissButton: .cancel(TextState(Localizable.ok)))
		
	case let .didCodeStartEnter(value):
		state.code = value
		
	case .didConfrimButtonTapped:
		guard let service = enviroment.authorizationService else { return .none }
		guard !state.code.isEmpty && !state.userId.uuidString.isEmpty else { return .init(value: .failedValidation(Localizable.fillAllFields)) }
		state.isLoading = true
		let confirmRequestData = Authorization_ConfirmCodeRequest.with {
			$0.code = state.code
			$0.userID = state.userId.uuidString
		}
		
		return service.confirmCode(request: confirmRequestData)
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
