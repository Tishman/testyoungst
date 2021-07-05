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

public struct TextFieldView: UIViewRepresentable, YoungstTextFieldDelegate {
    @Binding private var text: String
    @Binding private var forceFocused: Bool
    @Binding private var isSecure: Bool
    @Binding private var charecterLimit: Int
    private let placeholder: String?
    private let isCodeInput: Bool
    private let keyboardType: YoungstKeyboardType
    @Environment (\.multilineTextAlignment) private var alignment
    
    public init(text: Binding<String>,
                forceFocused: Binding<Bool>,
                isSecure: Binding<Bool>,
                charecterLimit: Binding<Int>,
                placeholder: String?,
                isCodeInput: Bool,
                keyboardType: YoungstKeyboardType = .default) {
        self._text = text
        self._forceFocused = forceFocused
        self.placeholder = placeholder
        self._charecterLimit = charecterLimit
        self._isSecure = isSecure
        self.isCodeInput = isCodeInput
        self.keyboardType = keyboardType
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textField = YoungstTextField(textInset: isCodeInput ? .zero : YoungstTextField.defaultInsets)
        textField.youngstDelegate = self
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        context.coordinator.initalSetup(textField: textField)
        textField.placeholder = placeholder
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        // TODO: Remove binding
        uiView.isSecureTextEntry = isSecure
        
        uiView.textAlignment = alignment.nsTextAligment
        
        if forceFocused {
            uiView.becomeFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(view: self)
    }
    
    func deleteBackward() {
        if isCodeInput {
            text = ""
        }
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
            textField.keyboardType = view.keyboardType.uiKitType
            
            if view.isCodeInput {
                textField.tintColor = .clear
            }
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
