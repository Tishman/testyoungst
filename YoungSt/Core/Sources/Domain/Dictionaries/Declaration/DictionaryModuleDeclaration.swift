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

final class DictionaryModuleDeclaration: DIPart, ModuleStoreProvider {
    
    private let environment: DictionariesEnvironment
    private let input: DictionariesInput
    
    private init(environment: DictionariesEnvironment, input: DictionariesInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(DictionariesEnvironment.init)
        
        container.register { env in { input in
            NavigationView {
                ViewHolder(storeProvider: DictionaryModuleDeclaration(environment: env, input: input),
                           content: DictionariesScene.init)
            }
            .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<DictionariesState, DictionariesAction> {
        .init(initialState: .init(userID: input.userID), reducer: dictionariesReducer, environment: environment)
    }
}
