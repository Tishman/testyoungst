//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import Resources
import Utilities

struct AddWordLanguageHeader: View {
    
    let leftText: String
    let rightText: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(leftText)
            
            Spacer()
            
            Button(action: action) {
                Asset.Images.arrowsSwap.swiftUI
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
            }
            .buttonStyle(InaccentButtonStyle())
            
            Spacer()
            
            Text(rightText)
            
            Spacer()
        }
        .font(.body)
    }
}

struct AddWordLanguageHeader_Previews: PreviewProvider {
    static var previews: some View {
        AddWordLanguageHeader(leftText: "Русский",
                              rightText: "Английский",
                              action: {})
    }
}
