//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture
import Coordinator
import Combine
import SwiftLazy
import Resources

struct SearchStudentRoutingPoints {
    let shareProfile: ShareProfileController.Endpoint
}

final class SearchStudentController: UIHostingController<SearchStudentScene>, ClosableController, UISearchResultsUpdating, RoutableController {
    
    typealias Endpoint = Provider<SearchStudentController>
    
    private let store: Store<SearchStudentState, SearchStudentAction>
    private let viewStore: ViewStore<SearchStudentState, SearchStudentAction>
    private let routingPoints: SearchStudentRoutingPoints
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var closePublisher: AnyPublisher<Bool, Never> {
        viewStore.publisher.isClosed.eraseToAnyPublisher()
    }
    
    var routePublisher: AnyPublisher<SearchStudentState.Routing?, Never> {
        viewStore.publisher.routing
            .handleEvents(receiveOutput: { [weak viewStore] point in
                guard let viewStore = viewStore, point != nil else { return }
                viewStore.send(.routingHandled)
            })
            .eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()
    
    init(env: SearchStudentEnvironment, routingPoints: SearchStudentRoutingPoints) {
        let store = Store<SearchStudentState, SearchStudentAction>(initialState: .init(),
                                                                   reducer: searchStudentReducer,
                                                                   environment: env)
        self.store = store
        self.viewStore = .init(store)
        self.routingPoints = routingPoints
        
        super.init(rootView: SearchStudentScene(store: store))
        
        observeClosing().store(in: &bag)
        observeRouting().store(in: &bag)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizable.searchStudents
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewStore.send(.searchTextChanged(text))
    }
    
    func handle(routing: SearchStudentState.Routing) {
        switch routing {
        case .shareLink:
            let vc = routingPoints.shareProfile.value
            present(controller: vc, preferredPresentation: .detail)
        }
    }
    
}
