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

final class ShareProfileController: UIHostingController<ShareProfileScene>, ClosableController {
    
    typealias Endpoint = Provider<ShareProfileController>
    
    var closePublisher: AnyPublisher<Bool, Never> { viewStore.publisher.isClosed.eraseToAnyPublisher() }
    
    private let store: Store<ShareProfileState, ShareProfileAction>
    private let viewStore: ViewStore<ShareProfileState, ShareProfileAction>
    private var bag = Set<AnyCancellable>()
    
    init(env: ShareProfileEnvironment) {
        let store = Store(initialState: ShareProfileState(), reducer: shareProfileReducer, environment: env)
        self.store = store
        self.viewStore = .init(store)
        super.init(rootView: ShareProfileScene(store: store))
        
        observeClosing().store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
