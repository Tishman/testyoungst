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

final class AddGroupController: UIHostingController<AddGroupScene> {
    
    typealias Endpoint = Provider1<AddGroupController, UUID>
    
    private let store: Store<AddGroupState, AddGroupAction>
    private let viewStore: ViewStore<AddGroupState, AddGroupAction>
    private var bag = Set<AnyCancellable>()
    private let routingPoints: AddGroupRoutingPoints
    
    init(userID: UUID, env: AddGroupEnvironment, routingPoints: AddGroupRoutingPoints) {
        self.store = Store(initialState: AddGroupState(userID: userID), reducer: addGroupReducer, environment: env)
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        
        super.init(rootView: AddGroupScene(store: store))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStore.publisher.addWordOpened
            .removeDuplicates()
            .filter { $0 }
            .sink(receiveValue: { [weak self, weak viewStore] _ in
                guard let self = self, let viewStore = viewStore else { return }
                self.present(self.routingPoints.addWord.value(
                    .init(semantic: .addLater(handler: .init { viewStore.send(.wordAdded($0)) }),
                          userID: viewStore.userID,
                          groupSelectionEnabled: false)
                ), animated: true)
            })
            .store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
