//
//  MainViewController.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import UIKit
import SwiftUI
import Coordinator
import ComposableArchitecture
import Combine
import Resources

struct AppScene: UIViewControllerRepresentable {
    
    let coordinator: Coordinator
    let store: Store<AppState, AppAction>
    
    func makeUIViewController(context: Context) -> AppViewController {
        .init(coordinator: coordinator, store: store)
    }
    
    func updateUIViewController(_ uiViewController: AppViewController, context: Context) {
        // nothing to do
    }
}

final class AppViewController: UIViewController {
    
    private let coordinator: Coordinator
    private let store: Store<AppState, AppAction>
    private let viewStore: ViewStore<AppState, AppAction>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: Coordinator, store: Store<AppState, AppAction>) {
        self.coordinator = coordinator
        self.store = store
        self.viewStore = .init(store)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.scope(state: \.authorizedState)
            .ifLet(then: { [weak self] store in
                self?.setAuthorizedState(userID: ViewStore(store).userID)
            }) { [weak self] in
                self?.setLoginState()
            }
            .store(in: &cancellables)
        
        viewStore.send(.appLaunched)
    }
    
    private func setAuthorizedState(userID: UUID) {
        let dictionariesView = coordinator.view(for: .dictionaries(.init(userID: userID))).uiKitHosted
		dictionariesView.tabBarItem = .init(title: Localizable.dictionary, image: UIImage(systemName: "rectangle.stack"), tag: 0)
        
        let profileView = coordinator.view(for: .profile(.init(userID: userID))).uiKitHosted
		profileView.tabBarItem = .init(title: Localizable.profile, image: UIImage(systemName: "person.crop.circle"), tag: 1)
        
        ViewEmbedder.embed(child: dictionariesView, to: self)
    }
    
    private func setLoginState() {
        let loginView = coordinator.view(for: .authorization(.default)).uiKitHosted
        ViewEmbedder.embed(child: loginView, to: self)
    }
}

class ViewEmbedder {
    
    class func embed(child:UIViewController, to parent:UIViewController) {
        
        parent.children.forEach(removeFromParent(vc:))
        
        child.willMove(toParent: parent)
        parent.addChild(child)
        parent.view.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parent.view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
            parent.view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
            parent.view.topAnchor.constraint(equalTo: child.view.topAnchor),
            parent.view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor),
        ])
        
        child.didMove(toParent: parent)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
