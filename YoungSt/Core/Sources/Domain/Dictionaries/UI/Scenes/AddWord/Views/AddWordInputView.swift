//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct AddWordInputView: View {
    
    let subtitle: String
    let lineLimit: Int
    let delegate: TextEditingDelegate?
    @Binding var currentText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.caption)
            
            TextEditingView(text: $currentText, delegate: delegate)
                .lineLimit(lineLimit)
                .background(placeholder)
                .foregroundColor(.primary)
                .font(.body)
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
        AddWordInputView(subtitle: Localizable.word, lineLimit: 4, delegate: nil, currentText: .constant("Hello"))
    }
}
