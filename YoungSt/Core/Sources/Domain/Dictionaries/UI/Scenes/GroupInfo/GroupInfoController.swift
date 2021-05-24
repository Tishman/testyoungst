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

struct GroupInfoRoutingPoints {
    let addWord: AddWordController.Endpoint
}

final class GroupInfoController: UIHostingController<GroupInfoScene>, RoutableController {
    
    typealias Endpoint = Provider2<GroupInfoController, UUID, GroupInfoState.GroupInfo>
    
    var routePublisher: AnyPublisher<GroupInfoState.Routing?, Never> {
        viewStore.publisher.routing
            .handleEvents(receiveOutput: { [weak viewStore] point in
                guard let viewStore = viewStore, point != nil else { return }
                viewStore.send(.routingHandled)
            })
            .eraseToAnyPublisher()
    }
    
    private let store: Store<GroupInfoState, GroupInfoAction>
    private let viewStore: ViewStore<GroupInfoState, GroupInfoAction>
    private let routingPoints: GroupInfoRoutingPoints
    private var bag = Set<AnyCancellable>()
    
    init(userID: UUID, info: GroupInfoState.GroupInfo, env: GroupInfoEnvironment, routingPoints: GroupInfoRoutingPoints) {
        let store = Store(initialState: GroupInfoState(userID: userID, info: info), reducer: groupInfoReducer, environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        super.init(rootView: GroupInfoScene(store: store))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeRouting().store(in: &bag)
    }
    
    func handle(routing: GroupInfoState.Routing) {
        switch routing {
        case let .addWord(input):
            let vc = routingPoints.addWord.value(input)
            present(controller: vc, preferredPresentation: .sheet)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
