//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 17.06.2021.
//

import SwiftUI
import Utilities

struct AuthTextInput: View {
    @Binding var text: String
    @Binding var forceFocused: Bool
    @Binding var isSecureMode: Bool
    var isClearMode: Bool
    let charecterLimit: Int = 255
    let placeholder: String
    var status: TextEditStatus
    var delegate: AuthTextFieldDelegate?
    
    var body: some View {
        TextFieldView(text: $text,
                      forceFocused: $forceFocused,
                      isSecureMode: $isSecureMode,
                      isClearMode: isClearMode,
                      charecterLimit: charecterLimit,
                      placeholder: placeholder,
                      delegate: delegate)
//            .textFieldStyle(TextEditStyle(focused: $forceFocused, status: status))
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        AuthTextInput(text: .constant(""),
                      forceFocused: .constant(true),
                      isSecureMode: .constant(false),
                      isClearMode: true,
                      placeholder: "Test",
                      status: .default,
                      delegate: nil)
    }
}
