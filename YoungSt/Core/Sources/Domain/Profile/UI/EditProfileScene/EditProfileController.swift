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

final class EditProfileController: UIHostingController<EditProfileScene>, ClosableController {
    
    typealias Endpoint = Provider<EditProfileController>
    
    var closePublisher: AnyPublisher<Bool, Never> {
        viewStore.publisher.isClosed.eraseToAnyPublisher()
    }
    
    private let store: Store<EditProfileState, EditProfileAction>
    private let viewStore: ViewStore<EditProfileState, EditProfileAction>
    private var bag = Set<AnyCancellable>()
    
    init(env: EditProfileEnvironment) {
        let store = Store(initialState: EditProfileState(shouldFetchProfile: true), reducer: editProfileReducer, environment: env)
        self.store = store
        self.viewStore = .init(store)
        super.init(rootView: EditProfileScene(store: store))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeClosing().store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
