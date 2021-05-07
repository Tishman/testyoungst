//
//  TabScene.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import SwiftUI
import UIKit
import Coordinator
import Resources
import ComposableArchitecture
import Combine

final class TabController: UIViewController {
    
    let coordinator: Coordinator
    let store: Store<TabState, TabAction>
    let viewStore: ViewStore<TabState, TabAction>
    
    var cancellable = Set<AnyCancellable>()
    
    private let dictionaries: UIHostingController<AnyView>
    private let profile: UIHostingController<AnyView>
    
    private let tabBarView: UIHostingController<AnyView>
    private var tabBarHeightConstraint: NSLayoutConstraint!
    private var blurHeightConstraint: NSLayoutConstraint!
    
    init(coordinator: Coordinator, store: Store<TabState, TabAction>) {
        self.coordinator = coordinator
        self.store = store
        
        let viewStore = ViewStore(store)
        self.viewStore = viewStore
        
        self.dictionaries = coordinator.view(for: .dictionaries(.init(userID: viewStore.userID))).uiKitHosted
        self.profile = coordinator.view(for: .profile(.init(userID: viewStore.userID))).uiKitHosted
        
        self.tabBarView = WithViewStore(store) { viewStore in
            TabBarView(leftItem: .init(id: .dictionaries, selectHandler: { viewStore.send(.selectedTabShanged(.dictionaries)) }),
                       rightItem: .init(id: .profile, selectHandler: { viewStore.send(.selectedTabShanged(.profile)) }),
                       selectedTab: viewStore.selectedTab,
                       mainButtonHandler: { viewStore.send(.mainButtonPressed) })
        }
        .erased
        .uiKitHosted
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarView.view.backgroundColor = .clear
        ViewEmbedder.embed(removing: [], child: tabBarView, to: self) { parent, child in
            tabBarHeightConstraint = child.view.heightAnchor.constraint(equalToConstant: 0)
            
            NSLayoutConstraint.activate([
                parent.view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
                parent.view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
                parent.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: child.view.bottomAnchor),
                tabBarHeightConstraint,
            ])
        }
        
        let blurView = UIView()
        blurView.backgroundColor = .systemBackground
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
            blurView.topAnchor.constraint(equalTo: tabBarView.view.topAnchor)
        ])
        
        viewStore.publisher.map(\.addWordOpened)
            .sink { [weak self] isOpened in
                if isOpened {
                    self?.showAddWordScene()
                }
            }
            .store(in: &cancellable)
        
        viewStore.publisher.map(\.selectedTab)
            .sink { [weak self] selectedTab in
                self?.updateSelectedTab(tab: selectedTab)
            }
            .store(in: &cancellable)
        updateSelectedTab(tab: .dictionaries)
    }
    
    private func showAddWordScene() {
        let box = Box<UIViewController>()
        let addWordVC = self.coordinator.view(for: .addWord(.init(closeHandler: { [weak self] in
            box.value?.dismiss(animated: true, completion: nil)
            self?.viewStore.send(.addWordOpened(false))
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }, semantic: .addToServer))).uiKitHosted
        box.value = addWordVC
        addWordVC.modalPresentationStyle = .automatic
        self.present(addWordVC, animated: true) {
            self.viewStore.send(.addWordOpened(false))
        }
    }
    
    private func updateSelectedTab(tab: TabItem.Identifier) {
        switch tab {
        case .dictionaries:
            ViewEmbedder.embed(removing: [profile], child: dictionaries, to: self)
        case .profile:
            ViewEmbedder.embed(removing: [dictionaries], child: profile, to: self)
        }
        view.setNeedsLayout()
    }
    
    private func updateChildLayout(child: UIViewController, newSafeInsets: UIEdgeInsets) {
        child.additionalSafeAreaInsets = newSafeInsets
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let preferredSize = tabBarView.sizeThatFits(in: view.bounds.size)
        tabBarHeightConstraint.constant = preferredSize.height
        
        tabBarView.view.setNeedsLayout()
        tabBarView.view.layoutIfNeeded()
        
        let newInsets = UIEdgeInsets(top: 0, left: 0, bottom: preferredSize.height, right: 0)
        
        [dictionaries, profile]
            .forEach { updateChildLayout(child: $0, newSafeInsets: newInsets) }
    }
    
}

class Box<T: AnyObject> {
    weak var value: T?
    
    init() {}
}