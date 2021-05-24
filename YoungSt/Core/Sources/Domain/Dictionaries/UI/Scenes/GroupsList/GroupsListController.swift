//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import SwiftLazy
import Combine

final class GroupsListController: UIHostingController<GroupsListScene>, ClosableController {
    
    typealias Endpoint = Provider2<GroupsListController, UUID, Binding<DictGroupItem?>>
    
    var closePublisher: AnyPublisher<Bool, Never> {
        viewStore.publisher.isClosed.eraseToAnyPublisher()
    }
    
    private let store: Store<GroupsListState, GroupsListAction>
    private let viewStore: ViewStore<GroupsListState, GroupsListAction>
    private let selectedGroup: Binding<DictGroupItem?>
    private var bag = Set<AnyCancellable>()
    
    init(userID: UUID, selectedGroup: Binding<DictGroupItem?>, env: GroupsListEnvironment) {
        let store = Store(initialState: GroupsListState(userID: userID), reducer: groupsListReducer, environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.selectedGroup = selectedGroup
        super.init(rootView: GroupsListScene(store: store))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeClosing().store(in: &bag)
        
        viewStore.publisher.selectedItem
            .sink(receiveValue: { [selectedGroup] selectedItem in
                selectedGroup.wrappedValue = selectedItem
            })
            .store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
