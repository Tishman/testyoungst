//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI

struct BubbleModifier: ViewModifier {
    let borderColor: Color
    let foregroundColor: Color
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                bubble
                    .foregroundColor(foregroundColor)
            )
            .overlay(
                bubble
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
    
    private var bubble: some Shape {
        RoundedRectangle(cornerRadius: .corner(.big), style: .continuous)
    }
}

public extension View {
    func bubbled(borderColor: Color, foregroundColor: Color, lineWidth: CGFloat) -> some View {
        self.modifier(BubbleModifier(borderColor: borderColor, foregroundColor: foregroundColor, lineWidth: lineWidth))
    }
}

