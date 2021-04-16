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
    
    private let environment: WelcomeEnviroment
    private let input: AuthorizationInput
    
    private init(environment: WelcomeEnviroment, input: AuthorizationInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(WelcomeEnviroment.init)
        
        container.register { env in { input in
            ViewHolder(storeProvider: ModuleDelaration(environment: env, input: input)) { store in
                WelcomeView(store: store)
            }
            .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<WelcomeState, WelcomeAction> {
        .init(initialState: .init(), reducer: welcomeReducer, environment: environment)
    }
}
