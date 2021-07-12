//
//  File.swift
//  
//
//  Created by Nikita Patskov on 07.06.2021.
//

import Foundation
import UIKit
import Combine

final class KeyboardObserver {
    
    static let shared = KeyboardObserver()
    
    private var isKeyboardVisibleSubject = PassthroughSubject<KeyboardNotification, Never>()
    
    struct KeyboardNotification {
        let isKeyboardVisible: Bool
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    var isKeyboardVisible: Bool = false
    
    var keyboardVisibilityChangedPublisher: AnyPublisher<KeyboardNotification, Never> {
        isKeyboardVisibleSubject.eraseToAnyPublisher()
    }
    
    @objc private func didShowKeyboard(notification: Notification) {
        isKeyboardVisible = true
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: true))
    }
    
    @objc private func didHideKeyboard(notification: Notification) {
        isKeyboardVisible = false
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: false))
    }
    
}
