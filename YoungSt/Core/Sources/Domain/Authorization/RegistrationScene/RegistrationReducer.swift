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
	confrimEmailReducer.optional().pullback(state: \.confrimCodeState,
								action: /RegistrationAction.confrimCode,
								environment: { ConfrimEmailEnviroment(authorizationService: $0.authorizationService) }),
	Reducer { state, action, enviroment in
		switch action {
		case .showPasswordButtonTapped(.password):
			state.isPasswordShowed.toggle()
			
		case .showPasswordButtonTapped(.confrimPassword):
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
			
		case let .didRecieveRegistartionResult(.failure(value)):
            state.alert = .init(title: TextState(value.localizedDescription))
			
		case let .failedValidtion(value):
            state.alert = .init(title: TextState(value))
			
		case .alertClosed:
            state.alert = nil
			
        case .registrationButtonTapped:
            guard !state.email.isEmpty && !state.password.isEmpty && !state.nickname.isEmpty else {
                return .init(value: .failedValidtion(Localizable.fillAllFields))
            }
            guard state.confrimPassword == state.password else { return .init(value: .failedValidtion(Localizable.passwordConfrimation)) }
            
            let requestData = Authorization_RegistrationRequest.with {
				$0.email = state.email
				$0.login = state.nickname
				$0.password = state.password
			}
			
			return enviroment.authorizationService.register(request: requestData)
				.receive(on: DispatchQueue.main)
				.catchToEffect()
				.map(RegistrationAction.didRecieveRegistartionResult)
            
        case .confrimCodeClosed:
            state.confrimCodeState = nil
            
        case .confrimCode(.finishRegistartion):
            state.confrimCodeState = nil
            return .init(value: .finishRegistration)
            
        case .finishRegistration, .confrimCode:
            break
        }
		
		return .none
	}
)
