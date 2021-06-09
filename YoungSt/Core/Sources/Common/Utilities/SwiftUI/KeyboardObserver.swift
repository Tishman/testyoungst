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
    
    private var isKeyboardVisibleSubject = CurrentValueSubject<KeyboardNotification, Never>(.init(isKeyboardVisible: false))
    
    struct KeyboardNotification {
        
        let isKeyboardVisible: Bool
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    var isKeyboardVisible: Bool {
        isKeyboardVisibleSubject.value.isKeyboardVisible
    }
    
    var keyboardVisibilityChangedPublisher: AnyPublisher<KeyboardNotification, Never> {
        isKeyboardVisibleSubject.eraseToAnyPublisher()
    }
    
    @objc private func didShowKeyboard(notification: Notification) {
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: true))
    }
    
    @objc private func didHideKeyboard(notification: Notification) {
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: false))
    }
    
}
