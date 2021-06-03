//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.06.2021.
//

import UIKit
import SwiftUI

public protocol TextEditingDelegate {
    func onCommit()
}

public struct TextEditingView: UIViewRepresentable {
    
    public init(text: Binding<String>, delegate: TextEditingDelegate?) {
        self._text = text
        self.delegate = delegate
    }
    
    @Environment(\.lineLimit) private var lineLimit
    @Environment(\.font) private var font
    
    private let delegate: TextEditingDelegate?
    @Binding private var text: String
    
    public func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        context.coordinator.initialSetup(textView: view)
        view.font = UIFont.preferredFont(from: font ?? .body)
        view.textContainer.maximumNumberOfLines = lineLimit ?? 0
        
        return view
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.textContainer.maximumNumberOfLines = lineLimit ?? 0
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(delegate: delegate, view: self)
    }
    
    public final class Coordinator: NSObject, UITextViewDelegate {
        
        private let delegate: TextEditingDelegate?
        private let view: TextEditingView
        
        init(delegate: TextEditingDelegate?, view: TextEditingView) {
            self.delegate = delegate
            self.view = view
        }
        
        func initialSetup(textView: UITextView) {
            textView.delegate = self
            textView.backgroundColor = .clear
            textView.textContainerInset = .zero
            textView.textContainer.lineFragmentPadding = 0
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            view.text = textView.text
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            delegate?.onCommit()
        }
    }
    
}

private extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let uiFont: UIFont
        
        switch font {
        case .largeTitle:
            uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            uiFont = UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            uiFont = UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            uiFont = UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            uiFont = UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            uiFont = UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            uiFont = UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            uiFont = UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            uiFont = UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            fallthrough
        default:
            uiFont = UIFont.preferredFont(forTextStyle: .body)
        }
        
        return uiFont
    }
}
