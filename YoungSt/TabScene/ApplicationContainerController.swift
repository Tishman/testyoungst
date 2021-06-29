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
    private let settings: UIViewController
    private let tab: UITabBarController
    
    init(coordinator: Coordinator, store: Store<TabState, TabAction>) {
        self.store = store
        
        let viewStore = ViewStore(store)
        self.viewStore = viewStore
        
		self.dictionaries = Self.createDictionaries(coordinator: coordinator, userID: viewStore.userID)
        self.profile = Self.createProfiles(coordinator: coordinator, userID: viewStore.userID)
        self.settings = UINavigationController(rootViewController: coordinator.view(for: .settings(.init())))
        settings.tabBarItem = Self.tabBarItem(from: .settings)
        
        let sidebar = SidebarViewController(store: store)
        let sidebarNav = UINavigationController(rootViewController: sidebar)
        
        self.tab = UITabBarController()
        
        super.init(style: .tripleColumn)
        
        self.primaryBackgroundStyle = .sidebar
        tab.setViewControllers([Self.createDictionaries(coordinator: coordinator, userID: viewStore.userID),
                                Self.createProfiles(coordinator: coordinator, userID: viewStore.userID),
                                settings],
                               animated: false)
        
        configureDisplayMode(size: nil)
        
        setViewController(sidebarNav, for: .primary)
        updateSelectedTab(tab: viewStore.selectedTab)
        
        setViewController(emptyDetailVC, for: .secondary)
        setViewController(tab, for: .compact)
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplayMode(size: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        configureDisplayMode(size: size)
    }
    
    private func configureDisplayMode(size: CGSize?) {
        #if targetEnvironment(macCatalyst)
        preferredSplitBehavior = .tile
        preferredDisplayMode = .twoBesideSecondary
        preferredPrimaryColumnWidth = UIFloat(320)
        #else
        let mediumIPadPortraitWidth: CGFloat = 834
        switch size?.width {
        case .some((mediumIPadPortraitWidth + 1)...):
            preferredDisplayMode = .oneBesideSecondary
            preferredSplitBehavior = .tile
        default:
            preferredDisplayMode = .twoDisplaceSecondary
            preferredSplitBehavior = .displace
        }
        #endif
    }
    
    static private func createDictionaries(coordinator: Coordinator, userID: UUID) -> UINavigationController {
        let dictionaries = UINavigationController(rootViewController: coordinator.view(for: .dictionaries(.init(userID: userID))))
        dictionaries.tabBarItem = tabBarItem(from: .dictionaries)
        return dictionaries
    }
    
    static private func createProfiles(coordinator: Coordinator, userID: UUID) -> UINavigationController {
        let profile = UINavigationController(rootViewController: coordinator.view(for: .profile(.init(userID: userID))))
        profile.tabBarItem = tabBarItem(from: .profile)
        return profile
    }
    
    static private func tabBarItem(from tabItem: TabItem) -> UITabBarItem {
        .init(title: tabItem.title,
              image: .init(systemName: tabItem.imageName),
              selectedImage: .init(systemName: tabItem.accentImageName))
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
    
    private func updateSelectedTab(tab: TabItem) {
        switch tab {
        case .dictionaries:
            setViewController(dictionaries, for: .supplementary)
        case .profile:
            setViewController(profile, for: .supplementary)
        case .settings:
            setViewController(settings, for: .supplementary)
        }
    }
    
}

class Box<T: AnyObject> {
    weak var value: T?
    
    init() {}
}
