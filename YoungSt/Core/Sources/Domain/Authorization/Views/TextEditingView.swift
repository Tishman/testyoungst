//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources

struct TextEditingView: View {
    let placholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placholder, text: $text)
            .padding()
            .bubbled(color: Asset.Colors.greenLightly.color.swiftuiColor, lineWidth: 1)
            .cornerRadius(.corner(.big))
    }
}

struct TextEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditingView(placholder: "Text", text: .constant(""))
    }
}
