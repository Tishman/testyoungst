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
import Utilities


final class ApplicationContainerController: UISplitViewController, UISplitViewControllerDelegate, SplitResetter {
    
    let store: Store<TabState, TabAction>
    let viewStore: ViewStore<TabState, TabAction>
    
    var cancellable = Set<AnyCancellable>()
    
    private let dictionaries: UIViewController
    private let profile: UIViewController
    private let tab: UITabBarController
    
    init(coordinator: Coordinator, store: Store<TabState, TabAction>) {
        self.store = store
        
        let viewStore = ViewStore(store)
        self.viewStore = viewStore
        
        self.dictionaries = UINavigationController(rootViewController: coordinator.view(for: .dictionaries(.init(userID: viewStore.userID))))
        let dictItem = TabItem.Identifier.dictionaries
        self.dictionaries.tabBarItem = .init(title: dictItem.title,
                                             image: .init(systemName: dictItem.imageName),
                                             selectedImage: .init(systemName: dictItem.accentImageName))
        
        self.profile = UINavigationController(rootViewController: coordinator.view(for: .profile(.init(userID: viewStore.userID))))
        let profileItem = TabItem.Identifier.profile
        self.profile.tabBarItem = .init(title: profileItem.title,
                                        image: .init(systemName: profileItem.imageName),
                                        selectedImage: .init(systemName: profileItem.accentImageName))
        
        let sidebar = WithViewStore(store) { viewStore in
            List {
                Button { viewStore.send(.selectedTabShanged(.dictionaries)) } label: {
                    Label(TabItem.Identifier.dictionaries.title, systemImage: TabItem.Identifier.dictionaries.imageName)
                }
                Button { viewStore.send(.selectedTabShanged(.profile)) } label: {
                    Label(TabItem.Identifier.profile.title, systemImage: TabItem.Identifier.profile.imageName)
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("YoungSt")
        .navigationBarTitleDisplayMode(.large)
        .uiKitHosted
        
        self.tab = UITabBarController()
        
        super.init(style: .tripleColumn)
        
        tab.setViewControllers([dictionaries, profile], animated: false)
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        
        setViewController(sidebar, for: .primary)
        setViewController(profile, for: .supplementary)
        
        self.setViewController(emptyDetailVC, for: .secondary)
//        setViewController(tab, for: .compact)
        self.delegate = self
    }
    
    func resetSplitDetailToEmpty(caller: UIViewController) {
        
        if self.isCollapsed {
            // We cant just set new detail controller in collapsed mode. It will cause runtime crash
            // We should:
            // pop back to master
            caller.navigationController?.navigationController?.popViewController(animated: true)
            
            // set new detail, because user should see empty when move back to expanded presentation.
            // All withour animation to prevent UI glitches
            UIView.setAnimationsEnabled(false)
            self.setViewController(emptyDetailVC, for: .secondary)
            // setting new detail will automatically push it to stack so we should pop it back again
            caller.navigationController?.navigationController?.popViewController(animated: false)
            UIView.setAnimationsEnabled(true)
            // should enabled
        } else {
            self.setViewController(emptyDetailVC, for: .secondary)
        }
        
    }
    
    private let emptyDetailVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        return UINavigationController(rootViewController: vc)
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStore.publisher.map(\.selectedTab)
            .sink { [weak self] selectedTab in
                self?.updateSelectedTab(tab: selectedTab)
            }
            .store(in: &cancellable)
        updateSelectedTab(tab: .dictionaries)
    }
    
    private func updateSelectedTab(tab: TabItem.Identifier) {
        switch tab {
        case .dictionaries:
            setViewController(dictionaries, for: .supplementary)
        case .profile:
            setViewController(profile, for: .supplementary)
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, willShow column: UISplitViewController.Column) {
        guard column == .compact else { return }
        splitViewController?.setViewController(UIViewController(), for: .supplementary)
        splitViewController?.setViewController(UIViewController(), for: .secondary)
        
        tab.setViewControllers([dictionaries, profile], animated: false)
    }
    
    func splitViewController(_ svc: UISplitViewController, willHide column: UISplitViewController.Column) {
        guard column == .compact else { return }
        
        setViewController(UIViewController(), for: .primary)
        setViewController(dictionaries, for: .supplementary)
    }
    
}

class Box<T: AnyObject> {
    weak var value: T?
    
    init() {}
}
