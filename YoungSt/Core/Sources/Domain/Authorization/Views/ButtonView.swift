//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources

struct ButtonView: View {
    let text: String
    let clouser: () -> Void
    
    var body: some View {
        Button(action: { clouser() }, label: {
            Text(text)
                .padding()
                .foregroundColor(.white)
                .background(Asset.Colors.greenDark.color.swiftuiColor)
                .cornerRadius(.corner(.small))
        })
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Text", clouser: {})
    }
}
