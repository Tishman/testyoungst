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
    case .route(.handled):
        state.routing = nil
    case .route(.login):
        state.routing = .login
    case .route(.registration):
        state.routing = .registration
    }
    return .none
}
.analytics()
