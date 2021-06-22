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
        
        viewStore.publisher.map(\.uiState)
            .removeDuplicates()
            .sink { [weak self] newUIState in
                self?.handleChange(uiState: newUIState)
            }
            .store(in: &cancellables)

        viewStore.publisher.map(\.deeplink)
            .compactMap { $0 }
            .sink { [weak self] deeplink in
                self?.handleChange(deeplink: deeplink)
            }
            .store(in: &cancellables)
        
        viewStore.send(.appLaunched)
    }
    
    private func handleChange(deeplink: Deeplink) {
        switch deeplink {
        case let .studentInvite(invite):
            let studentInviteVC = coordinator.view(for: .studentInvite(.init(invite: invite)))
            topViewController(root: self).present(studentInviteVC, animated: true) { [viewStore] in
                viewStore.send(.deeplinkHandled)
            }
        }
    }

    private func handleChange(uiState: AppState.UIState) {
        switch uiState {
        case let .authorized(userID):
			setAuthorizedState(userID: userID)
        case .authorization:
            setLoginState()
        case .onboarding:
            setOnboardingState()
        }
    }

	private func setAuthorizedState(userID: UUID) {
        let container = ApplicationContainerController(coordinator: coordinator,
													   store: .init(initialState: .init(userID: userID),
                                                                    reducer: tabReducer,
                                                                    environment: ()))
        let alertController = UIAlertController(title: Localizable.welcomeMessage, message: nil, preferredStyle: .alert)
        alertController.addAction(.init(title: Localizable.ok, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        ViewEmbedder.embed(child: container, to: self)
    }
    
    private func setLoginState() {
		let loginView = coordinator.view(for: .authorization(WelcomeInput()))
        ViewEmbedder.embed(child: loginView, to: self)
    }

    private func setOnboardingState() {
        let onboarding = Text("Onboarding").uiKitHosted
        ViewEmbedder.embed(child: onboarding, to: self)
    }

    func topViewController(root: UIViewController) -> UIViewController {
        if let tab = root as? UITabBarController {
            return tab.selectedViewController.map(topViewController) ?? root
        } else if let navigation = root as? UINavigationController {
            return navigation.visibleViewController.map(topViewController) ?? root
        } else if let presented = root.presentedViewController {
            return topViewController(root: presented)
        } else {
            return root
        }
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

