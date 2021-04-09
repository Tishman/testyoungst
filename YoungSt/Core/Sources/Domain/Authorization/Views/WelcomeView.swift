//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 07.04.2021.
//

import SwiftUI

struct WelcomeView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.title)
                .bold()
            
            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, .spacing(.regular))
        }
        .padding(.horizontal)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(title: "Welcome!", subtitle: "Let's start!")
    }
}
