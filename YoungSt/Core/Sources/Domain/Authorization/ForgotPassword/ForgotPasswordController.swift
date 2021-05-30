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

final class ForgotPasswordController: UIHostingController<ForgotPasswordScene>, ClosableController {
	typealias Endpoint = Provider<ForgotPasswordController>
	
	var closePublisher: AnyPublisher<Bool, Never> {
		viewStore.publisher.isClosed.eraseToAnyPublisher()
	}
	
	private let store: Store<ForgotPasswordState, ForgotPasswordAction>
	private let viewStore: ViewStore<ForgotPasswordState, ForgotPasswordAction>
	private var bag = Set<AnyCancellable>()
	
	init(env: ForgotPasswordEnviroment) {
		let store = Store(initialState: ForgotPasswordState(),
						  reducer: forgotPasswordReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
		super.init(rootView: ForgotPasswordScene(store: store))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeClosing().store(in: &bag)
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
