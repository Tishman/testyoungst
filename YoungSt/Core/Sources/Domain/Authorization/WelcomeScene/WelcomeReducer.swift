//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import ComposableArchitecture

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnviroment>.combine(
    Reducer { state, action, enviroment in
        switch action {
            
        case .viewsClosed:
            state.loginState = nil
            state.registrationState = nil
			
        case .registration(.finishRegistration):
			state.registrationState = nil
			
		case .login, .registration:
			break
		}
        return .none
    }
)
