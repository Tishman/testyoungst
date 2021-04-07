//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 07.04.2021.
//

import SwiftUI

public struct WelcomeView: View {
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public let title: String
    public let subtitle: String
    
    public var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: 28))
                .bold()
            
            Text(subtitle)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, .spacing(.regular))
                .padding(.horizontal, 100)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(title: "Welcome!", subtitle: "Let's start!")
    }
}
