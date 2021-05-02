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

struct AppScene2: View {
    
    let coordinator: Coordinator
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                IfLetStore(store.scope(state: \.authorizedState),
                           then: { store in
                            WithViewStore(store) { viewStore in
                                coordinator.view(for: .dictionaries(.init(userID: viewStore.state.userID)))
                            }
                           },
                           else: {
                            coordinator.view(for: .authorization(.default))
                           })
            }
            .onAppear { viewStore.send(.appLaunched) }
        }
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
        dictionariesView.tabBarItem = .init(title: Localizable.dictionary, image: .init(systemName: "rectangle.stack"), tag: 0)
        
        let profileView = coordinator.view(for: .profile(.init(userID: userID))).uiKitHosted
        profileView.tabBarItem = .init(title: Localizable.profile, image: .init(systemName: "person.crop.circle"), tag: 1)
        
        ViewEmbedder.embed(child: dictionariesView, to: self)
//        setViewControllers([dictionariesView, profileView], animated: false)
        //        self.setTabBar(hidden: false, animated: false)
    }
    
    private func setLoginState() {
        let loginView = coordinator.view(for: .authorization(.default)).uiKitHosted
        ViewEmbedder.embed(child: loginView, to: self)
//        setViewControllers([loginView], animated: false)
        //        self.setTabBar(hidden: true, animated: false)
    }
    
    func setTabBar(
        hidden: Bool,
        animated: Bool = true,
        along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil
    ) {
        guard isTabBarHidden != hidden else { return }
        
        //        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        //        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        //        let vc: UIViewController? = viewControllers?[selectedIndex]
        //        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        //        let originalInsets = newInsets
        //        newInsets?.bottom -= offsetY
        //
        //        /// Helper method for updating child view controller's safe area insets.
        //        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
        //            cvc?.additionalSafeAreaInsets = additionalSafeArea
        //            cvc?.view.setNeedsLayout()
        //        }
        //
        //        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        //        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }
        //
        //        guard animated else {
        //            tabBar.frame = endFrame
        //            return
        //        }
        //
        //        // Perform animation with coordinato if one is given. Update safe area insets _after_ the animation is complete,
        //        // if we're showing the tab bar.
        //        weak var tabBarRef = self.tabBar
        //        if let tc = transitionCoordinator {
        //            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
        //                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
        //                    set(childViewController: vc, additionalSafeArea: insets)
        //                }
        //            }
        //        } else {
        //            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
        //                if !hidden, didFinish, let insets = newInsets {
        //                    set(childViewController: vc, additionalSafeArea: insets)
        //                }
        //            }
        //        }
    }
    
    /// `true` if the tab bar is currently hidden.
    var isTabBarHidden: Bool {
        true
        //        return !tabBar.frame.intersects(view.frame)
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
