//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import SwiftLazy
import Combine
import Coordinator

final class ShareProfileController: UIHostingController<ShareProfileScene> {
    
    typealias Endpoint = Provider1<ShareProfileController, UUID>
    
    private let store: Store<ShareProfileState, ShareProfileAction>
    private let viewStore: ViewStore<ShareProfileState, ShareProfileAction>
    
    init(userID: UUID, env: ShareProfileEnvironment) {
        let store = Store(initialState: ShareProfileState(userID: userID), reducer: shareProfileReducer, environment: env)
        self.store = store
        self.viewStore = .init(store)
        super.init(rootView: ShareProfileScene(store: store))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
