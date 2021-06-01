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
            
            Text(leftText)
                .frame(maxWidth: .infinity)
            
            Button(action: action) {
                Asset.Images.arrowsSwap.swiftUI
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIFloat(18), height: UIFloat(18))
            }
            .buttonStyle(InaccentButtonStyle())
            
            Text(rightText)
                .frame(maxWidth: .infinity)
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
