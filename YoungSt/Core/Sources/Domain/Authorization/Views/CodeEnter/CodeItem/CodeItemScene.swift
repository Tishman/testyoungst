//
//  File.swift
//  
//
//  Created by Роман Тищенко on 30.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

private let circle = Circle()

struct CodeItem: View {
    let store: Store<CodeItemState, CodeItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            TextFieldView(text: viewStore.binding(get: \.text, send: CodeItemAction.textUpdated),
                          forceFocused: viewStore.binding(get: \.forceFocused, send: CodeItemAction.forcedFocus),
                          isSecure: false,
                          charecterLimit: viewStore.binding(get: \.characterLimit, send: CodeItemAction.characterLimitUpdated),
                          placeholder: nil,
                          isCodeInput: true,
                          keyboardType: .numberPad)
                .frame(width: UIFloat(50), height: UIFloat(50))
                .background(
                    circle
                        .foregroundColor(Asset.Colors.greenLightly.color.swiftuiColor)
                )
                .overlay(
                    circle
                        .strokeBorder(lineWidth: 1)
                        .foregroundColor(Asset.Colors.greenDark.color.swiftuiColor)
                )
        }
        .multilineTextAlignment(.center)
        .clipShape(circle)
    }
}
