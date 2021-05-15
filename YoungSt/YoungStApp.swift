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
import Coordinator
import Authorization
import Utilities
import Resources


@main
struct YoungStApp: App {
    private let container: DIContainer
    private let coordinator: Coordinator
    private let deeplinkService: DeeplinkService
    
    let store: Store<AppState, AppAction>
    
    init() {
        let container = ApplicationDI.container
        
        self.container = container
        self.coordinator = container.resolve()
        self.deeplinkService = container.resolve()
        self.store = .init(initialState: .init(),
                           reducer: appReducer,
                           environment: container.resolve())
    }
    
    var body: some Scene {
        WindowGroup {
            AppScene(coordinator: coordinator, store: store)
                .edgesIgnoringSafeArea(.all)
                .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
                .environment(\.coordinator, container.resolve())
                .onOpenURL(perform: handle(deeplink:))
        }
    }
    
    private func handle(deeplink: URL) {
        guard let deeplink = deeplinkService.transform(deeplinkURL: deeplink) else {
            return
        }
        ViewStore(store).send(.handleDeeplink(deeplink))
    }
}

