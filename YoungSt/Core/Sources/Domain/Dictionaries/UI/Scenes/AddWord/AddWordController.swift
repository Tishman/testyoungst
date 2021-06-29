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

struct AddWordRoutingPoints {
    let groupsList: GroupsListController.Endpoint
}

final class AddWordController: UIHostingController<AddWordScene>, RoutableController, ClosableController {
    
    typealias Endpoint = Provider1<AddWordController, AddWordInput>
    
    private let store: Store<AddWordState, AddWordAction>
    private let viewStore: ViewStore<AddWordState, AddWordAction>
    
    var closePublisher: AnyPublisher<Bool, Never> { viewStore.publisher.isClosed.eraseToAnyPublisher() }
    
    var routePublisher: AnyPublisher<AddWordState.Routing?, Never> {
        viewStore.publisher.routing
            .handleEvents(receiveOutput: { [weak viewStore] point in
                guard let viewStore = viewStore, point != nil else { return }
                viewStore.send(.routingHandled)
            })
            .eraseToAnyPublisher()
    }
    
    private let routingPoints: AddWordRoutingPoints
    private var bag = Set<AnyCancellable>()
    
    init(input: AddWordInput, env: AddWordEnvironment, langProvider: LanguagePairProvider, routingPoints: AddWordRoutingPoints) {
        let store = Store(initialState: .init(input: input,
                                              sourceLanguage: langProvider.sourceLanguage,
                                              destinationLanguage: langProvider.destinationLanguage),
                          reducer: addWordReducer,
                          environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        super.init(rootView: AddWordScene(store: store))
        
        observeRouting().store(in: &bag)
        observeClosing().store(in: &bag)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if let navigationController = parent as? UINavigationController {
            navigationController.navigationBar.backgroundColor = .clear
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
    }
    
    func handle(routing: AddWordState.Routing) {
        switch routing {
        case let .groupsList(userID):
            let vc = routingPoints.groupsList.value(userID, viewStore.binding(get: {
                $0.selectedGroup.map { DictGroupItem(id: $0.id, alias: nil, state: .init(title: "", subtitle: "")) }
            }, send: AddWordAction.selectedGroupChanged))
            present(controller: vc, preferredPresentation: .detail)
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
