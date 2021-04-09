//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI

public struct RoundedStyle: ButtonStyle {
    public init(color: Color) {
        self.color = color
    }
    
    let color: Color
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.4) : .white)
            .background(color)
            .cornerRadius(.corner(.small))
    }
}
