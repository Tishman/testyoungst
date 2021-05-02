//
//  File.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import DITranquillity
import Coordinator
import SwiftUI
import Utilities
import ComposableArchitecture

final class ProfileModuleDeclaration: DIPart, ModuleStoreProvider {
    
    private let environment: ProfileEnvironment
    private let input: ProfileInput
    
    private init(environment: ProfileEnvironment, input: ProfileInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(ProfileEnvironment.init)
        
        container.register { env in { input in
            NavigationView {
                ViewHolder(storeProvider: ProfileModuleDeclaration(environment: env, input: input),
                           content: ProfileScene.init)
            }
            .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<ProfileState, ProfileAction> {
        .init(initialState: .init(userID: input.userID), reducer: .empty, environment: environment)
    }
}
