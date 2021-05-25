//
//  File.swift
//  
//
//  Created by Nikita Patskov on 25.05.2021.
//

import Foundation


import UIKit
import SwiftUI
import ComposableArchitecture
import SwiftLazy
import Combine
import Coordinator



final class WelcomeController: UIHostingController<WelcomeView> {
    
    private let store: Store<WelcomeState, WelcomeAction>
    private var bag = Set<AnyCancellable>()
    
    init(env: WelcomeEnviroment) {
        let store = Store(initialState: WelcomeState(),
                          reducer: welcomeReducer,
                          environment: env)
        self.store = store

        super.init(rootView: WelcomeView(store: store))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
