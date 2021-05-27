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

final class StudentInviteController: UIHostingController<StudentInviteScene>, ClosableController {
    
    typealias Endpoint = Provider<StudentInviteController>
    
    var closePublisher: AnyPublisher<Bool, Never> {
        viewStore.publisher.isClosed.eraseToAnyPublisher()
    }
    
    private let store: Store<StudentInviteState, StudentInviteAction>
    private let viewStore: ViewStore<StudentInviteState, StudentInviteAction>
    private var bag = Set<AnyCancellable>()
    
    init(input: StudentInviteInput, env: StudentInviteEnvironment) {
        let store = Store(initialState: StudentInviteState(input: input),
                          reducer: studentInviteReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        super.init(rootView: StudentInviteScene(store: store))
        
        observeClosing().store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
