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
                self?.setAuthorizedState(store: store)
            }) { [weak self] in
                self?.setLoginState()
            }
            .store(in: &cancellables)
        
        viewStore.send(.appLaunched)
    }
    
    private func setAuthorizedState(store: Store<TabState, AppAction>) {
        let tab = TabController(coordinator: coordinator, store: store.scope(state: { $0 }, action: AppAction.tab))
        ViewEmbedder.embed(child: tab, to: self)
    }
    
    private func setLoginState() {
        let loginView = coordinator.view(for: .authorization(.default)).uiKitHosted
        ViewEmbedder.embed(child: loginView, to: self)
    }
}

class ViewEmbedder {
    
    class func embed(removing: Set<UIViewController>?, child: UIViewController, to parent: UIViewController, layout: (_ parent: UIViewController, _ child: UIViewController) -> Void) {
        
        if child.parent == parent {
            return
        }
        let removing = removing ?? Set(parent.children)
        parent.children.filter(removing.contains).forEach(removeFromParent)
        
        child.willMove(toParent: parent)
        parent.addChild(child)
        parent.view.insertSubview(child.view, at: 0)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        layout(parent, child)
        
        child.didMove(toParent: parent)
    }
    
    class func embed(removing: Set<UIViewController>? = nil, child: UIViewController, to parent: UIViewController) {
        embed(removing: removing, child: child, to: parent) { parent, child in
            NSLayoutConstraint.activate([
                parent.view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
                parent.view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
                parent.view.topAnchor.constraint(equalTo: child.view.topAnchor),
                parent.view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor),
            ])
        }
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
