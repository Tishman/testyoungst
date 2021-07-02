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

struct VerificationRoutingPoints {
    let changePassword: ChangePasswordController.Endpoint
}

final class VerificationController: UIHostingController<VerificationScene>, RoutableController {
    typealias Endpoint = Provider1<VerificationController, String>
    
    private let store: Store<VerificationState, VerificationAction>
    private let viewStore: ViewStore<VerificationState, VerificationAction>
    
    private let routingPoints: VerificationRoutingPoints
    private var bag = Set<AnyCancellable>()
    
    var routePublisher: AnyPublisher<VerificationState.Routing?, Never> {
        viewStore.publisher.routing.eraseToAnyPublisher()
    }
    
    func resetRouting() {
        viewStore.send(.routingHandled)
    }
    
    init(email: String, env: VerificationEnviroment, routingPoints: VerificationRoutingPoints) {
        let store = Store(initialState: VerificationState(email: email),
                          reducer: verificationReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        super.init(rootView: VerificationScene(store: store))
        observeRouting().store(in: &bag)
    }
    
    func handle(routing: VerificationState.Routing) {
        switch routing {
        case let .changePassword(email: email, code: code):
            let vc = routingPoints.changePassword.value(.init(email: email, code: code))
            present(controller: vc, preferredPresentation: .pushInCurrent)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
