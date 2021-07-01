//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture

final class SettingsController: UIHostingController<SettingsScene> {
    
    let store: Store<SettingsState, SettingsAction>
    
    init(env: SettingsEnvironment) {
        let store = Store<SettingsState, SettingsAction>(initialState: .init(), reducer: settingsReducer, environment: env)
        
        self.store = store
        
        super.init(rootView: SettingsScene(store: store))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
