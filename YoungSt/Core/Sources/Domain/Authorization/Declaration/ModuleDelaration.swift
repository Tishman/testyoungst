//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import DITranquillity
import Coordinator
import SwiftUI
import Utilities
import ComposableArchitecture

final class ModuleDelaration: DIPart, ModuleStoreProvider {
    
    private let environment: LoginEnviroment
    private let input: AuthorizationInput
    
    private init(environment: LoginEnviroment, input: AuthorizationInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(LoginEnviroment.init)
        
        container.register { env in { input in
            ViewHolder(storeProvider: ModuleDelaration(environment: env, input: input)) { store in
                LoginView(store: store)
            }
            .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<LoginState, LoginAction> {
        .init(initialState: .init(), reducer: loginReducer, environment: environment)
    }
}
