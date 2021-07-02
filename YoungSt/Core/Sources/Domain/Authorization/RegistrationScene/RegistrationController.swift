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
import Utilities
import Coordinator
import SwiftLazy

struct RegistrationRoutingPoints {
	let confirmEmail: ConfrimEmailController.Endpoint
}

final class RegistrationController: UIHostingController<RegistrationView>, RoutableController {
	typealias Endpoint = Provider<RegistrationController>
	
	private let store: Store<RegistrationState, RegistrationAction>
	private let viewStore: ViewStore<RegistrationState, RegistrationAction>
	
	private let routingPoints: RegistrationRoutingPoints
	private var bag = Set<AnyCancellable>()
	
	var routePublisher: AnyPublisher<RegistrationState.Routing?, Never> {
		viewStore.publisher.routing.eraseToAnyPublisher()
	}
    
    func resetRouting() {
        viewStore.send(.routingHandled)
    }
	
	init(env: RegistrationEnviroment, routingPoints: RegistrationRoutingPoints) {
		let store = Store(initialState: RegistrationState(),
						  reducer: registrationReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
		self.routingPoints = routingPoints
		super.init(rootView: RegistrationView(store: store))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeRouting().store(in: &bag)
	}
	
	func handle(routing: RegistrationState.Routing) {
		switch routing {
        case let .confrimEmail(userId: userId, email: email, password: password):
            let vc = routingPoints.confirmEmail.value(.init(userId: userId, email: email, password: password))
			present(controller: vc, preferredPresentation: .detail)
		}
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
