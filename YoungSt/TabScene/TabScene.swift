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
import Introspect

extension View {
    public func introspectSplitViewController(customize: @escaping (UISplitViewController) -> ()) -> some View {
        return inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController in
                // Search in ancestors
                if let splitController = introspectionViewController.splitViewController {
                    return splitController
                }
                
                // Search in siblings
                return Introspect.previousSibling(containing: UISplitViewController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }
}

struct NativeApplicationContainerView: View {
    internal init(coordinator: Coordinator, store: Store<TabState, TabAction>, userID: UUID) {
        self.coordinator = coordinator
        self.store = store
        
        dictionariesView = coordinator.view(for: .dictionaries(.init(userID: userID)))
        currentProfileView = coordinator.view(for: .profile(.init(userID: userID)))
    }
    
    
    let coordinator: Coordinator
    let store: Store<TabState, TabAction>
    
    let dictionariesView: AnyView
    let currentProfileView: AnyView
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        content
            .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder private var content: some View {
        if horizontalSizeClass == .regular {
            NavigationView {
                WithViewStore(store) { viewStore in
                    List {
                        NavigationLink(destination: dictionariesView,
                                       tag: TabItem.Identifier.dictionaries,
                                       selection: viewStore.binding(get: { $0.selectedTab }, send: { .selectedTabShanged($0) }),
                                       label: {
                                        Label(TabItem.Identifier.dictionaries.title, systemImage: TabItem.Identifier.dictionaries.imageName)
                                       })
                        
                        NavigationLink(destination: currentProfileView,
                                       tag: TabItem.Identifier.profile,
                                       selection: viewStore.binding(get: { $0.selectedTab }, send: { .selectedTabShanged($0) }),
                                       label: {
                                        Label(TabItem.Identifier.profile.title, systemImage: TabItem.Identifier.profile.imageName)
                                       })
                    }
                }
                .listStyle(SidebarListStyle())
                .introspectSplitViewController(customize: configure)
                .navigationTitle("YoungSt")

                WithViewStore(store) { viewStore in
                    switch viewStore.selectedTab {
                        case .dictionaries:
                            dictionariesView
                        case .profile:
                            currentProfileView
                    }
                }
                .frame(minWidth: 320)
                .introspectSplitViewController(customize: configure)


                EmptyView()
                    .introspectSplitViewController(customize: configure)
            }
        } else {
            compactTabView
        }
    }
    
    private func configure(split: UISplitViewController) {
        split.preferredDisplayMode = .oneBesideSecondary
        split.preferredSplitBehavior = .tile
    }
    
    private var compactTabView: some View {
        WithViewStore(store) { viewStore in
            TabView(selection: viewStore.binding(get: \.selectedTab.rawValue, send: { .selectedTabShanged(.init(rawValue: $0)!) })) {
                NavigationView {
                    dictionariesView
                }
                .tabItem {
                    Label(TabItem.Identifier.dictionaries.title,
                          systemImage: TabItem.Identifier.dictionaries.imageName)
                }
                .tag(TabItem.Identifier.dictionaries.rawValue)
                
                NavigationView {
                    currentProfileView
                }
                .tabItem {
                    Label(TabItem.Identifier.profile.title, systemImage: TabItem.Identifier.profile.imageName)
                }
                .tag(TabItem.Identifier.profile.rawValue)
            }
        }
    }
}


final class ApplicationContainerController: UIViewController {
    
    let coordinator: Coordinator
    let store: Store<TabState, TabAction>
    let viewStore: ViewStore<TabState, TabAction>
    
    var cancellable = Set<AnyCancellable>()
    
    private let dictionaries: UIViewController
    private let profile: UIViewController
    
    private let tabBarView: UIHostingController<AnyView>
    private var tabBarHeightConstraint: NSLayoutConstraint!
    private var blurHeightConstraint: NSLayoutConstraint!
    
    init(coordinator: Coordinator, store: Store<TabState, TabAction>) {
        self.coordinator = coordinator
        self.store = store
        
        let viewStore = ViewStore(store)
        self.viewStore = viewStore
        
        self.dictionaries = UINavigationController(rootViewController: coordinator.view(for: .dictionaries(.init(userID: viewStore.userID))).uiKitHosted)
        
        self.profile = UINavigationController(rootViewController: coordinator.view(for: .profile(.init(userID: viewStore.userID))).uiKitHosted)
        
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
        
        viewStore.publisher
            .sink { [weak self] state in
                if state.addWordOpened {
                    self?.showAddWordScene(userID: state.userID)
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
    
    private func showAddWordScene(userID: UUID) {
        let vc = Box<UIViewController>()
        let closeHandler = { [weak self] in
            vc.value?.dismiss(animated: true)
            self?.viewStore.send(.addWordOpened(false))
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
        
        let addWordController = coordinator.view(for: .addWord(.init(closeHandler: .init(closeHandler),
                                                                     semantic: .addToServer,
                                                                     userID: userID,
                                                                     groupSelectionEnabled: true))).uiKitHosted
        vc.value = addWordController
        present(addWordController, animated: true) {
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
