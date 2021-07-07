//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 17.06.2021.
//

import SwiftUI
import Utilities
import Resources

struct AuthTextInput: View {
    @Binding var text: String
    @Binding var forceFocused: Bool
    let status: TextEditStatus
    let charecterLimit: Int = 255
    let placeholder: String
    var submitHandler: (() -> Void)?

    var body: some View {
        HStack(spacing: .spacing(.small)) {
            TextFieldView(text: $text,
                          forceFocused: $forceFocused,
                          isSecure: false,
                          charecterLimit: .constant(charecterLimit),
                          placeholder: placeholder,
                          isCodeInput: false,
                          onSubmit: submitHandler ?? TextFieldView.hideKeyboard)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: { text = "" }) {
                Image(uiImage: Asset.Images.cross.image)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .padding(.trailing)
        }
        .inputField(focused: $forceFocused, status: status)
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        AuthTextInput(text: .constant(""),
                      forceFocused: .constant(false),
                      status: .default,
                      placeholder: "Test",
                      submitHandler: {})
    }
}
