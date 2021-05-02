//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture
import GRDB
import NetworkService
import DITranquillity
import TranslateScene
import Coordinator
import Authorization
import Utilities
import Resources

@main
struct YoungStApp: App {
    private let container: DIContainer
    private let coordinator: Coordinator
    
    let store = Store<AppState, AppAction>.init(initialState: AppState(),
                                                reducer: appReducer,
                                                environment: environment)
    
    init() {
        let container = ApplicationDI.container
        
        self.container = container
        self.coordinator = container.resolve()
    }
    
    static var environment: AppEnviroment {
        AppEnviroment(userProvider: ApplicationDI.container.resolve(),
                      credentialsService: ApplicationDI.container.resolve())
    }
    
    var body: some Scene {
        WindowGroup {
            AppScene.init(coordinator: coordinator, store: store)
                .edgesIgnoringSafeArea(.all)
//            coordinator.view(for: .dictionaries(.init(userID: nil)))
                .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
        }
    }
}
 
