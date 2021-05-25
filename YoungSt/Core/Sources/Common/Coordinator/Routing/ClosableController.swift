//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import Combine
import UIKit

public protocol ClosableState {
    var isClosed: Bool { get }
}

public protocol ClosableController: AnyObject {
    var closePublisher: AnyPublisher<Bool, Never> { get }
}

public extension ClosableController where Self: UIViewController {
    func observeClosing() -> AnyCancellable {
        closePublisher.filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                if let navigation = self?.navigationController, navigation.viewControllers.count > 1 {
                    navigation.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            })
    }
}
