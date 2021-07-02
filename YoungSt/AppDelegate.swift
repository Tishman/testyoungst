//
//  AppDelegate.swift
//  YoungSt
//
//  Created by Nikita Patskov on 25.06.2021.
//

import UIKit
import Protocols
import ComposableArchitecture

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let container = ApplicationDI.container
    private let deeplinkService: DeeplinkService = ApplicationDI.container.resolve()
    
    var appStore: ViewStore<AppState, AppAction>!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        container.initializeSingletonObjects()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let webpageURL = userActivity.webpageURL else { return false }
        
        return deeplinkService.handle(remoteLink: webpageURL) { url in
            guard let url = url, let deeplink = self.deeplinkService.transform(deeplinkURL: url) else { return }
            self.appStore.send(.handleDeeplink(deeplink))
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return application(app, open: url,
                             sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                             annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        guard let deeplinkURL = deeplinkService.handle(customSchemeURL: url),
              let deeplink = deeplinkService.transform(deeplinkURL: deeplinkURL)
        else { return false }
        
        appStore.send(.handleDeeplink(deeplink))
        return true
    }
}
