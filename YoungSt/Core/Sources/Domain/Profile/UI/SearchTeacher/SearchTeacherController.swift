//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture
import Coordinator
import Combine
import SwiftLazy
import Resources

final class SearchTeacherController: UIHostingController<SearchTeacherScene>, ClosableController, UISearchResultsUpdating {
    
    typealias Endpoint = Provider<SearchTeacherController>
    
    private let store: Store<SearchTeacherState, SearchTeacherAction>
    private let viewStore: ViewStore<SearchTeacherState, SearchTeacherAction>
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var closePublisher: AnyPublisher<Bool, Never> {
        viewStore.publisher.isClosed.eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()
    
    init(env: SearchTeacherEnvironment) {
        let store = Store<SearchTeacherState, SearchTeacherAction>(initialState: .init(),
                                                                   reducer: searchTeacherReducer,
                                                                   environment: env)
        self.store = store
        self.viewStore = .init(store)
        
        super.init(rootView: SearchTeacherScene(store: store))
        
        observeClosing().store(in: &bag)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizable.searchTeachers
        
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
    
}
