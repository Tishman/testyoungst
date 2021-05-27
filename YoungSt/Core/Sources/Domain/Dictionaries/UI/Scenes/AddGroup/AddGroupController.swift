//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Coordinator
import Protocols
import SwiftLazy
import Combine

struct AddGroupRoutingPoints {
    let addWord: AddWordController.Endpoint
}

final class AddGroupController: UIHostingController<AddGroupScene>, ClosableController, RoutableController {
    
    typealias Endpoint = Provider1<AddGroupController, UUID>
    
    var closePublisher: AnyPublisher<Bool, Never> { viewStore.publisher.isClosed.eraseToAnyPublisher() }
    var routePublisher: AnyPublisher<AddGroupState.Routing?, Never> {
        viewStore.publisher.routing
            .handleEvents(receiveOutput: { [weak viewStore] routing in
                guard let viewStore = viewStore, routing != nil else { return }
                viewStore.send(.rountingHandled)
            })
            .eraseToAnyPublisher()
    }
    
    private let store: Store<AddGroupState, AddGroupAction>
    private let viewStore: ViewStore<AddGroupState, AddGroupAction>
    private var bag = Set<AnyCancellable>()
    private let routingPoints: AddGroupRoutingPoints
    
    init(userID: UUID, env: AddGroupEnvironment, routingPoints: AddGroupRoutingPoints) {
        self.store = Store(initialState: AddGroupState(userID: userID), reducer: addGroupReducer, environment: env)
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        
        super.init(rootView: AddGroupScene(store: store))
        
        observeRouting().store(in: &bag)
        observeClosing().store(in: &bag)
    }
    
    func handle(routing: AddGroupState.Routing) {
        switch routing {
        case .addWord:
            let addWordController = self.routingPoints.addWord.value(
                .init(semantic: .addLater(handler: .init { [weak viewStore] in viewStore?.send(.wordAdded($0)) }),
                      userID: viewStore.userID,
                      groupSelectionEnabled: false)
            )
            present(controller: addWordController, preferredPresentation: .sheet)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
