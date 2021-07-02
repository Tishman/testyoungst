//
//  File.swift
//  
//
//  Created by Роман Тищенко on 28.05.2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import ComposableArchitecture
import SwiftLazy
import Coordinator
import Utilities

struct  ForgotPasswordRoutingPoints {
    let verification: VerificationController.Endpoint
}

final class ForgotPasswordController: UIHostingController<ForgotPasswordScene>, RoutableController {
	typealias Endpoint = Provider<ForgotPasswordController>
	
	private let store: Store<ForgotPasswordState, ForgotPasswordAction>
	private let viewStore: ViewStore<ForgotPasswordState, ForgotPasswordAction>
    private let routingPoints: ForgotPasswordRoutingPoints
	private var bag = Set<AnyCancellable>()
	
	init(env: ForgotPasswordEnviroment, routingPoints: ForgotPasswordRoutingPoints) {
		let store = Store(initialState: ForgotPasswordState(),
						  reducer: forgotPasswordReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
        self.routingPoints = routingPoints
        super.init(rootView: ForgotPasswordScene(store: store))
        observeRouting().store(in: &bag)
	}
    
    var routePublisher: AnyPublisher<ForgotPasswordState.Routing?, Never> {
        viewStore.publisher.routing.eraseToAnyPublisher()
    }
    
    func resetRouting() {
        viewStore.send(.routingHandled)
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    func handle(routing: ForgotPasswordState.Routing) {
        switch routing {
        case let .verification(email: email):
            let vc = routingPoints.verification.value(email)
            present(controller: vc, preferredPresentation: .pushInCurrent)
        }
    }
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
