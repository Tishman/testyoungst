//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.06.2021.
//

import Foundation
import SwiftUI
import UIKit
import Resources

public struct TextFieldView: UIViewRepresentable {
    @Binding private var text: String
    @Binding private var forceFocused: Bool
    @Binding private var isSecure: Bool
    private let placeholder: String?
    private let charecterLimit: Int
    
    public init(text: Binding<String>,
                forceFocused: Binding<Bool>,
                isSecure: Binding<Bool>,
                charecterLimit: Int,
                placeholder: String?) {
        self._text = text
        self._forceFocused = forceFocused
        self.placeholder = placeholder
        self.charecterLimit = charecterLimit
        self._isSecure = isSecure
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textField = UITextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        context.coordinator.initalSetup(textField: textField)
        textField.placeholder = placeholder
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        uiView.isSecureTextEntry = isSecure

        if forceFocused {
            uiView.becomeFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        private let view: TextFieldView
        
        init(view: TextFieldView) {
            self.view = view
        }
        
        func initalSetup(textField: UITextField) {
            textField.delegate = self
            textField.font = .preferredFont(forTextStyle: .body)
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        @objc private func textFieldDidChange(_ textField: UITextField) {
            view.text = textField.text ?? ""
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            view.forceFocused = true
        }
        
        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            view.forceFocused = false
            textField.resignFirstResponder()
            return true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return textLimit(existingText: textField.text, newText: string)
        }
        
        private func textLimit(existingText: String?, newText: String) -> Bool {
            let text = existingText ?? ""
            let isAtLimit = text.count + newText.count <= view.charecterLimit
            return isAtLimit
        }
    }
}
