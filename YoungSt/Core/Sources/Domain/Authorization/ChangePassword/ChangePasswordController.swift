//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import Coordinator
import ComposableArchitecture
import SwiftLazy
import Utilities

final class ChangePasswordController: UIHostingController<ChangePasswordScene>, RoutableController {
    typealias Endpoint = Provider1<ChangePasswordController, ChangePasswordInput>
    
    private let store: Store<ChangePasswordState, ChangePasswordAction>
    private let viewStore: ViewStore<ChangePasswordState, ChangePasswordAction>
    private var bag = Set<AnyCancellable>()
    
    init(input: ChangePasswordInput, env: ChangePasswordEnviroment) {
        let store = Store(initialState: ChangePasswordState(email: input.email, code: input.code),
                          reducer: changePasswordReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        super.init(rootView: ChangePasswordScene(store: store))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeRouting().store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var routePublisher: AnyPublisher<ChangePasswordState.Routing?, Never> {
        viewStore.publisher.routing.eraseToAnyPublisher()
    }
    
    func resetRouting() {
        viewStore.send(.routingHandled)
    }
    
    func handle(routing: ChangePasswordState.Routing) {
        switch routing {
        case .passwordChanged:
            guard let vc = navigationController?.viewControllers[1] else { return }
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}
