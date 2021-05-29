//
//  File.swift
//  
//
//  Created by Роман Тищенко on 26.05.2021.
//

import Foundation
import Coordinator
import UIKit
import SwiftUI
import ComposableArchitecture
import SwiftLazy
import Combine

struct WelcomeRoutingPoints {
	let login: LoginController.Endpoint
	let registration: RegistrationController.Endpoint
}

final class WelcomeViewController: UIHostingController<WelcomeView>, RoutableController {
	typealias Endpoint = Provider1<WelcomeViewController, WelcomeInput>
	
	private let store: Store<WelcomeState, WelcomeAction>
	private let viewStore: ViewStore<WelcomeState, WelcomeAction>
	
	private let routingPoints: WelcomeRoutingPoints
	private var bag = Set<AnyCancellable>()
	
	var routePublisher: AnyPublisher<WelcomeState.Routing?, Never> {
		viewStore.publisher.routing
			.handleEvents(receiveOutput: { [weak viewStore] point in
				guard let viewStore = viewStore, point != nil else { return }
				viewStore.send(.routingHandled)
			})
			.eraseToAnyPublisher()
	}
	
	init(input: WelcomeInput, env: WelcomeEnviroment, routingPoints: WelcomeRoutingPoints) {
		let store = Store(initialState: WelcomeState(),
						  reducer: welcomeReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
		self.routingPoints = routingPoints
		super.init(rootView: WelcomeView(store: store))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeRouting().store(in: &bag)
	}
	
	func handle(routing: WelcomeState.Routing) {
		switch routing {
		case .login:
			let vc = routingPoints.login.value
			present(controller: vc, preferredPresentation: .detail)
		case .registration:
			let vc = routingPoints.registration.value
			present(controller: vc, preferredPresentation: .detail)
		}
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
