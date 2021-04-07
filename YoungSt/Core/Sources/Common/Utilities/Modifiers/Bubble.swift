//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI

struct Bubble: ViewModifier {
    let color: Color
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: .corner(.big), style: .continuous)
                    .stroke(color, lineWidth: lineWidth)
                    .background(color)
            )
    }
}

public extension View {
    func bubble(color: Color, lineWidth: CGFloat) -> some View {
        self.modifier(Bubble(color: color, lineWidth: lineWidth))
    }
}
