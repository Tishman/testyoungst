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
    @Binding var status: TextEditStatus
    let charecterLimit: Int = 255
    let placeholder: String
    
    var body: some View {
        HStack(spacing: .spacing(.small)) {
            TextFieldView(text: $text,
                          forceFocused: $forceFocused,
                          isSecure: .constant(false),
                          charecterLimit: charecterLimit,
                          placeholder: placeholder)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(uiImage: Asset.Images.cross.image)
                }
            }
        }
        .inputField(focused: $forceFocused, status: status)
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        AuthTextInput(text: .constant(""),
                      forceFocused: .constant(false),
                      status: .constant(.default),
                      placeholder: "Test")
    }
}
