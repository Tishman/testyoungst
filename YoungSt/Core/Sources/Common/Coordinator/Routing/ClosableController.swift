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

public protocol SplitResetter {
    func resetSplitDetailToEmpty(caller: UIViewController)
}

public extension ClosableController where Self: UIViewController {
    func observeClosing() -> AnyCancellable {
        closePublisher.filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                if let navigation = self.navigationController, navigation.viewControllers.count > 1 {
                    navigation.popViewController(animated: true)
                } else if self.presentingViewController != nil {
                    self.dismiss(animated: true)
                } else if let splitResetter = self.splitViewController as? SplitResetter {
                    splitResetter.resetSplitDetailToEmpty(caller: self)
                }
            })
    }
}
