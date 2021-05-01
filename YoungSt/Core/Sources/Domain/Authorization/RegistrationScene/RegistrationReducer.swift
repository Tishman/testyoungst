//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Utilities
import Resources
let registrationReducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnviroment>.combine(
	confrimCodeReducer.optional().pullback(state: \.confrimCodeState,
								action: /RegistrationAction.confrimCode,
								environment: { ConfrimCodeEnviroment(authorizationService: $0.authorizationService) }),
	Reducer { state, action, enviroment in
		switch action {
		case let .showPasswordButtonTapped(.password):
			state.isPasswordShowed.toggle()
			
		case let .showPasswordButtonTapped(.confrimPassword):
			state.isConfrimPasswordShowed.toggle()
		
		case let .didEmailChanged(value):
			state.email = value
			
		case let .didNicknameChange(value):
			state.nickname = value
			
		case let .didPasswordChanged(value):
			state.password = value
			
		case let .didConfrimPasswordChanged(value):
			state.confrimPassword = value
			
		case let .didRecieveRegistartionResult(.success(value)):
			state.confrimCodeState = .init(userId: value.uuidString)
			state.isCodeConfrimed = true
			
		case let .didRecieveRegistartionResult(.failure(value)):
			state.alertMessage = value.localizedDescription
			state.isAlertPresent = true
			
		case let .failedValidtion(value):
			state.alertMessage = value
			state.isAlertPresent = true
			
		case .alertPresented:
			state.alertMessage = ""
			state.isAlertPresent = false
			
		case .registrationButtonTapped:
			guard let authorizationService = enviroment.authorizationService,
					!state.email.isEmpty, !state.password.isEmpty &&
						!state.nickname.isEmpty else { return .init(value: .failedValidtion(Localizable.fillAllFields)) }
			guard state.confrimPassword == state.password else { return .init(value: .failedValidtion(Localizable.passwordConfrimation)) }
			
			let requestData = Authorization_RegistrationRequest.with {
				$0.email = state.email
				$0.nickname = state.nickname
				$0.password = state.password
			}
			
			return authorizationService.register(request: requestData)
				.receive(on: DispatchQueue.main)
				.catchToEffect()
				.map(RegistrationAction.didRecieveRegistartionResult)
			
		case .confrimCode(action: let action):
			state.isRegistrationSuccess = false
			break
		case .confrimCodeOpenned:
			break
		}
		
		return .none
	}
)
