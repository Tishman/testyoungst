//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import ComposableArchitecture

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnviroment>.combine(
    loginReducer.pullback(state: \.loginState,
                          action: /WelcomeAction.login(action:),
                          environment: { LoginEnviroment(service: $0.authorizationService) }),
    registrationReducer.pullback(state: \.registrationState,
                                 action: /WelcomeAction.registration(action:),
                                 environment: { RegistrationEnviroment(authorizationService: $0.authorizationService) }),
    Reducer { state, action, enviroment in
        switch action {
        case let .login(action: action):
            break
        case let .registration(action: action):
            break
        }
        return .none
    }
)
