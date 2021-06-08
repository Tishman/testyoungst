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
    
    private var isKeyboardVisibleSubject = CurrentValueSubject<KeyboardNotification, Never>(.init(isKeyboardVisible: false, animationProperties: .init(duration: 0)))
    
    struct KeyboardNotification {
        
        let isKeyboardVisible: Bool
        let animationProperties: AnimationProperties
        
        struct AnimationProperties {
            let duration: Double
        }
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
        let properties = KeyboardNotification.AnimationProperties(duration: 0.25)
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: true, animationProperties: properties))
    }
    
    @objc private func didHideKeyboard(notification: Notification) {
        let properties = KeyboardNotification.AnimationProperties(duration: 0.25)
        isKeyboardVisibleSubject.send(KeyboardNotification(isKeyboardVisible: false, animationProperties: properties))
    }
    
}
