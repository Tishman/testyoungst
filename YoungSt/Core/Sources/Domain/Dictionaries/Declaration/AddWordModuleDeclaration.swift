//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation

import Foundation
import DITranquillity
import Coordinator
import SwiftUI
import Utilities
import ComposableArchitecture
import Protocols

final class AddWordModuleDeclaration: DIPart, ModuleStoreProvider {
    
    private let environment: AddWordEnvironment
    private let input: AddWordInput
    private let languagePairProvider: LanguagePairProvider
    
    private init(environment: AddWordEnvironment, input: AddWordInput, languagePairProvider: LanguagePairProvider) {
        self.environment = environment
        self.input = input
        self.languagePairProvider = languagePairProvider
    }
    
    static func load(container: DIContainer) {
        container.register(AddWordEnvironment.init)
        
        container.register { env, pairProvider in { input -> AnyView in
            ViewHolder(storeProvider: AddWordModuleDeclaration(environment: env, input: input, languagePairProvider: pairProvider),
                       content: AddWordScene.init)
                .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<AddWordState, AddWordAction> {
        .init(initialState: .init(input: input, sourceLanguage: languagePairProvider.sourceLanguage, destinationLanguage: languagePairProvider.destinationLanguage),
              reducer: addWordReducer,
              environment: environment)
    }
}
