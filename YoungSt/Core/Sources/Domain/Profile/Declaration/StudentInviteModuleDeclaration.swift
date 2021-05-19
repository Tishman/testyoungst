//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import DITranquillity
import Coordinator
import SwiftUI
import Utilities
import ComposableArchitecture

final class StudentInviteModuleDeclaration: DIPart, ModuleStoreProvider {
    
    private let environment: StudentInviteEnvironment
    private let input: StudentInviteInput
    
    private init(environment: StudentInviteEnvironment, input: StudentInviteInput) {
        self.environment = environment
        self.input = input
    }
    
    static func load(container: DIContainer) {
        container.register(StudentInviteEnvironment.init)
        
        container.register { env in { input in
            NavigationView {
                ViewHolder(storeProvider: StudentInviteModuleDeclaration(environment: env, input: input),
                           content: StudentInviteScene.init)
            }
            .erased
        }
        }
    }
    
    func createInitialModuleStore() -> Store<StudentInviteState, StudentInviteAction> {
        .init(initialState: .init(input: input), reducer: studentInviteReducer, environment: environment)
    }
}
