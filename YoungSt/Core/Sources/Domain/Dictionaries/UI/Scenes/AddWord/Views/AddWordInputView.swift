//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources

struct AddWordInputView: View {
    
    let subtitle: String
    let lineLimit: Int
    @Binding var currentText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.caption)
            
            
            TextEditor(text: $currentText)
                .lineLimit(lineLimit)
                .background(placeholder)
                .foregroundColor(.primary)
                .font(.body)
                .introspectTextView {
                    $0.backgroundColor = .clear
                    $0.textContainerInset = .zero
                    $0.textContainer.lineFragmentPadding = 0
                }
        }
    }
    
    
    private var placeholder: some View {
        Text(currentText.isEmpty ? Localizable.typeText : "")
            .foregroundColor(.secondary)
            .greedy(aligningContentTo: .topLeading)
    }
}

struct AddWordInputView_Previews: PreviewProvider {
    static var previews: some View {
        AddWordInputView(subtitle: Localizable.word, lineLimit: 4, currentText: .constant("Hello"))
    }
}
