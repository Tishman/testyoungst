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
import Combine
import SwiftLazy
import Resources

struct DictionariesRoutingPoints {
    let addGroup: AddGroupController.Endpoint
    let groupInfo: GroupInfoController.Endpoint
    let addWord: AddWordController.Endpoint
}

final class DictionariesController: UIHostingController<DictionariesScene>, RoutableController {
    
    typealias Endpoint = Provider1<DictionariesController, DictionariesInput>
    
    private let store: Store<DictionariesState, DictionariesAction>
    private let viewStore: ViewStore<DictionariesState, DictionariesAction>
    
    private let routingPoints: DictionariesRoutingPoints
    private var bag = Set<AnyCancellable>()
    
    var routePublisher: AnyPublisher<DictionariesState.Routing?, Never> {
        viewStore.publisher.routing
            .handleEvents(receiveOutput: { [weak viewStore] point in
                guard let viewStore = viewStore, point != nil else { return }
                viewStore.send(.changeDetail(.closed))
            })
            .eraseToAnyPublisher()
    }
    
    init(input: DictionariesInput, env: DictionariesEnvironment, routingPoints: DictionariesRoutingPoints) {
		let store = Store(initialState: DictionariesState(userID: input.userID),
                          reducer: dictionariesReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        super.init(rootView: DictionariesScene(store: store))
        
        observeRouting().store(in: &bag)
    }
    
    func handle(routing: DictionariesState.Routing) {
        switch routing {
        case let .addWord(input):
            let vc = routingPoints.addWord.value(input)
            present(controller: vc, preferredPresentation: .sheet)
        case let .groupInfo(userID, info):
            let vc = routingPoints.groupInfo.value(userID, info)
            present(controller: vc, preferredPresentation: .detail)
        case let .addGroup(userID):
            let vc = routingPoints.addGroup.value(userID)
            present(controller: vc, preferredPresentation: .detail)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
