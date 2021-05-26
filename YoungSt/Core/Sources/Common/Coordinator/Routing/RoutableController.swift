//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import Combine
import UIKit

public enum PreferredPresentation: Equatable {
    case modal
    case sheet
    case detail
    case pushInCurrent
}

public protocol RoutableController: AnyObject {
    associatedtype Routing
    
    var routePublisher: AnyPublisher<Routing?, Never> { get }
    
    func present(controller: UIViewController, preferredPresentation: PreferredPresentation)
    func handle(routing: Routing)
}

public extension RoutableController {
    
    func observeRouting() -> AnyCancellable {
        routePublisher
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] in self?.handle(routing: $0) })
    }
}

public extension RoutableController where Self: UIViewController {
    
    func present(controller: UIViewController, preferredPresentation: PreferredPresentation) {
        
        func wrappedToNavigation() -> UIViewController {
            controller is UINavigationController ? controller : UINavigationController(rootViewController: controller)
        }
        
        switch preferredPresentation {
        case .modal:
            let controller = wrappedToNavigation()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)

        case .sheet:
            let controller = wrappedToNavigation()
            controller.modalPresentationStyle = .automatic
            present(controller, animated: true)

        case .detail:
            if let split = self.splitViewController, !split.isCollapsed {
                if let navigation = self.navigationController, split.viewControllers.last == navigation {
                    navigation.pushViewController(controller, animated: true)
                } else {
                    split.showDetailViewController(wrappedToNavigation(), sender: self)
                }
            } else if let navigation = self.navigationController {
                navigation.pushViewController(controller, animated: true)
            } else {
                show(controller, sender: self)
            }

        case .pushInCurrent:
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
