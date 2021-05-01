//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 07.04.2021.
//

import SwiftUI
import Resources

struct HeaderDescriptionView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
				.foregroundColor(Asset.Colors.greenDark.color.swiftuiColor)
                .font(.title)
                .bold()
            
            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, .spacing(.medium))
                .padding(.horizontal, .spacing(.superBig))
        }
        .padding(.horizontal)
    }
}

struct HeaderDescription_Previews: PreviewProvider {
    static var previews: some View {
        HeaderDescriptionView(title: "Welcome!", subtitle: "Let's start!")
    }
}
