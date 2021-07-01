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
import Coordinator
import ComposableArchitecture
import SwiftLazy
import Utilities

final class ConfrimEmailController: UIHostingController<ConfrimEmailScene>, ClosableController {
	typealias Endpoint = Provider1<ConfrimEmailController, ConfrimEmailInput>
	
	var closePublisher: AnyPublisher<Bool, Never> {
		viewStore.publisher.isClosed.eraseToAnyPublisher()
	}
	
	private let store: Store<ConfrimEmailState, ConfrimEmailAction>
	private let viewStore: ViewStore<ConfrimEmailState, ConfrimEmailAction>
	private var bag = Set<AnyCancellable>()
	
    init(input: ConfrimEmailInput, env: ConfrimEmailEnviroment) {
        let store = Store(initialState: ConfrimEmailState(userId: input.userId, email: input.email, passsword: input.password),
						  reducer: confrimEmailReducer,
						  environment: env)
		self.store = store
		self.viewStore = .init(store)
		super.init(rootView: ConfrimEmailScene(store: store))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		observeClosing().store(in: &bag)
	}
	
	@objc required dynamic init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
