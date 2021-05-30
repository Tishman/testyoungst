//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import ComposableArchitecture

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnviroment> { state, action, enviroment in
        switch action {
		case .routingHandled(.close):
			state.routing = nil
		case .routingHandled(.login):
			state.routing = .login
		case .routingHandled(.registration):
			state.routing = .registration
		}
        return .none
}
