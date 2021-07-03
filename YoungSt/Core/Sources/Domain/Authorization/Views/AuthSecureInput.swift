//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 21.06.2021.
//

import SwiftUI
import Utilities
import Resources

struct AuthSecureInput: View {
    @Binding var text: String
    @Binding var forceFocused: Bool
    @Binding var isSecure: Bool
    let status: TextEditStatus
    let charecterLimit: Int = 255
    let placeholder: String
    
    var body: some View {
        HStack(spacing: .spacing(.small)) {
            TextFieldView(text: $text,
                          forceFocused: $forceFocused,
                          isSecure: $isSecure,
                          charecterLimit: .constant(charecterLimit),
                          placeholder: placeholder,
                          isCursorHidden: false)
            if isSecure {
                Button(action: { isSecure.toggle() }) {
                    Image(uiImage: Asset.Images.emptyEye.image)
                }
            } else {
                Button(action: { isSecure.toggle() }) {
                    Image(uiImage: Asset.Images.eye.image)
                }
            }
        }
        .inputField(focused: $forceFocused, status: status)
    }
}

struct AuthSecureInput_Previews: PreviewProvider {
    static var previews: some View {
        AuthSecureInput(text: .constant(""),
                        forceFocused: .constant(false),
                        isSecure: .constant(true),
                        status: .default,
                        placeholder: "Preview")
    }
}
