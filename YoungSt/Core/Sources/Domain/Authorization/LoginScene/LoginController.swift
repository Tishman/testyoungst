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
import Utilities
import Coordinator

struct LoginRoutingPoints {
	let forgotPassword: ForgotPasswordController.Endpoint
	let confirmEmail: ConfrimEmailController.Endpoint
}

final class LoginController: UIHostingController<LoginView>, RoutableController {
	typealias Endpoint = Provider<LoginController>
	
	private let store: Store<LoginState, LoginAction>
	private let viewStore: ViewStore<LoginState, LoginAction>
	
	private let routingPoints: LoginRoutingPoints
	private var bag = Set<AnyCancellable>()
	
	var routePublisher: AnyPublisher<LoginState.Routing?, Never> {
		viewStore.publisher.routing.eraseToAnyPublisher()
	}
    
    func resetRouting() {
        viewStore.send(.routingHandled)
    }
	
	init(env: LoginEnviroment, routingPoints: LoginRoutingPoints) {
		let store = Store(initialState: LoginState(),
						  reducer: loginReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
		self.routingPoints = routingPoints
		super.init(rootView: LoginView(store: store))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeRouting().store(in: &bag)
	}
	
	func handle(routing: LoginState.Routing) {
		switch routing {
		case .forgotPassword:
			let vc = routingPoints.forgotPassword.value
			present(controller: vc, preferredPresentation: .pushInCurrent)
		case let .confirmEmail(userId: userId, email: email, password: password):
            let vc = routingPoints.confirmEmail.value(.init(userId: userId, email: email, password: password))
			present(controller: vc, preferredPresentation: .pushInCurrent)
		}
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
