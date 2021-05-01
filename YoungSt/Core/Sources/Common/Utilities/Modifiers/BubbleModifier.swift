//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import Resources

struct StrokedBubbleModifier: ViewModifier {
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

struct BubbleModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: .corner(.big))
                    .foregroundColor(color)
            )
    }
}

public extension View {
    func bubbled(borderColor: Color, foregroundColor: Color, lineWidth: CGFloat) -> some View {
        modifier(StrokedBubbleModifier(borderColor: borderColor, foregroundColor: foregroundColor, lineWidth: lineWidth))
    }
    
    func bubbled(color: Color = Asset.Colors.greenLightly.color.swiftuiColor) -> some View {
        modifier(BubbleModifier(color: color))
    }
}

