//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import ComposableArchitecture

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnviroment>.combine(
	loginReducer.optional().pullback(state: \.loginState,
                          action: /WelcomeAction.login,
                          environment: { LoginEnviroment(service: $0.authorizationService) }),
	registrationReducer.optional().pullback(state: \.registrationState,
                                 action: /WelcomeAction.registration,
                                 environment: { RegistrationEnviroment(authorizationService: $0.authorizationService) }),
    Reducer { state, action, enviroment in
        switch action {

		case .loginOpenned(let isOpen):
			state.loginState = isOpen ? .init() : nil
			
		case .registrationOppend(let isOpen):
			state.registrationState = isOpen ? .init() : nil
			
		case .registration(.confrimCode(.finishRegistartion)):
			state.registrationState = nil
			
		case .login, .registration:
			break
		}
        return .none
    }
)
