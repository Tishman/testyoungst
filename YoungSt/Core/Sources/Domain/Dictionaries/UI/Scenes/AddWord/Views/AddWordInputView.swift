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
    @Binding var currentText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.caption)
            
            TextEditor(text: $currentText)
                .lineLimit(4)
                .background(placeholder)
                .foregroundColor(.primary)
                .font(.body)
                .introspectTextView {
                    $0.backgroundColor = .clear
                    $0.textContainerInset = .zero
                    $0.textContainer.lineFragmentPadding = 0
                }
        }
        .padding()
        .frame(height: 130)
        .frame(maxWidth: .infinity)
        .bubbled()
    }
    
    
    private var placeholder: some View {
        Text(currentText.isEmpty ? Localizable.typeText : "")
            .foregroundColor(.secondary)
            .greedy(.topLeading)
    }
}

struct AddWordInputView_Previews: PreviewProvider {
    static var previews: some View {
        AddWordInputView(subtitle: Localizable.word, currentText: .constant("Hello"))
    }
}
