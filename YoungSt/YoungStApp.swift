//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture
import NetworkService
import DITranquillity
import Coordinator
import Authorization
import Utilities
import Resources
import Protocols

@main
struct YoungStApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
        appDelegate.appStore = ViewStore(store)
        
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            AppScene(coordinator: coordinator, store: store)
                .edgesIgnoringSafeArea(.all)
                .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
                .onOpenURL(perform: handle(deeplink:))
        }
    }
    
    func configureAppearance() {
        UINavigationBar.appearance().tintColor = Asset.Colors.greenDark.color
    }
    
    private func handle(deeplink: URL) {
        deeplinkService.handle(remoteLink: deeplink) { url in
            guard let url = url, let deeplink = deeplinkService.transform(deeplinkURL: url) else { return }
            ViewStore(store).send(.handleDeeplink(deeplink))
        }
    }
}

