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

struct DictionaryControllerWrapper: UIViewControllerRepresentable {
    
    let provider: DictionariesController.Endpoint
    
    let input: DictionariesInput
    
    func makeUIViewController(context: Context) -> DictionariesController {
        provider.value(input)
    }
    
    func updateUIViewController(_ uiViewController: DictionariesController, context: Context) {}
}

final class DictionaryModuleDeclaration: DIPart, ModuleStoreProvider {
    
    private let environment: DictionariesEnvironment
    private let input: DictionariesInput
    
    private init(environment: DictionariesEnvironment, input: DictionariesInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(DictionariesEnvironment.init)
        
        container.register { provider in { (input: DictionariesInput) in
            DictionaryControllerWrapper(provider: provider, input: input)
                .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<DictionariesState, DictionariesAction> {
        .init(initialState: .init(userID: input.userID, title: input.title), reducer: dictionariesReducer, environment: environment)
    }
}
