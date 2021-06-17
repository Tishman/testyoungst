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

public protocol TextFieldViewDelegate {
    func onEditingChanged(isEditing: Bool)
}

public struct TextFieldView: UIViewRepresentable {
    @Binding private var text: String
    @Binding private var forceFocused: Bool
    @Binding private var isSecureMode: Bool
    private let isClearMode: Bool
    private let placeholder: String?
    private let charecterLimit: Int
    private let delegate: TextFieldViewDelegate?
    
    public init(text: Binding<String>,
                forceFocused: Binding<Bool>,
                isSecureMode: Binding<Bool>,
                isClearMode: Bool,
                charecterLimit: Int,
                placeholder: String?,
                delegate: TextFieldViewDelegate?) {
        self._text = text
        self._forceFocused = forceFocused
        self._isSecureMode = isSecureMode
        self.isClearMode = isClearMode
        self.placeholder = placeholder
        self.charecterLimit = charecterLimit
        self.delegate = delegate
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let textField = UITextField()
        context.coordinator.initalSetup(textField: textField)
        textField.placeholder = placeholder
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        uiView.isSecureTextEntry = isSecureMode
        
        if forceFocused {
            uiView.becomeFirstResponder()
            DispatchQueue.main.async {
                forceFocused = false
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(delegate: delegate, view: self)
    }
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        private let delegate: TextFieldViewDelegate?
        private let view: TextFieldView
        
        init(delegate: TextFieldViewDelegate?, view: TextFieldView) {
            self.delegate = delegate
            self.view = view
        }
        
        func initalSetup(textField: UITextField) {
            textField.delegate = self
            textField.backgroundColor = .clear
            textField.font = .preferredFont(forTextStyle: .body)
            if view.isClearMode {
                textField.clearButtonMode = .whileEditing
            }
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 10
            textField.layer.borderColor = Asset.Colors.grayLight.color.cgColor
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            delegate?.onEditingChanged(isEditing: true)
            view.text = textField.text ?? ""
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            textLimit(existingText: textField.text, newText: string)
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            delegate?.onEditingChanged(isEditing: false)
            return true
        }
        
        private func textLimit(existingText: String?, newText: String) -> Bool {
            let text = existingText ?? ""
            let isAtLimit = text.count + newText.count <= view.charecterLimit
            return isAtLimit
        }
    }
}
