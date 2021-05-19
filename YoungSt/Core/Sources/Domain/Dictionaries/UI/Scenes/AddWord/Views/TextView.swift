//
//  File.swift
//  
//
//  Created by Nikita Patskov on 09.05.2021.
//

import UIKit
import SwiftUI

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    let background: UIColor
    let lineLimit: Int
    let onEditingChanged: ((Bool) -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        for view in textView.subviews {
            view.backgroundColor = background
        }
        textView.backgroundColor = background
        
        textView.delegate = context.coordinator
        
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }
    
    func makeCoordinator() -> Coordinator {
        .init(swiftUIView: self)
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textContainer.maximumNumberOfLines = lineLimit
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        private let swiftUIView: TextView
        
        init(swiftUIView: TextView) {
            self.swiftUIView = swiftUIView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            swiftUIView.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            swiftUIView.onEditingChanged?(true)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            swiftUIView.onEditingChanged?(false)
        }
    }
    
}
