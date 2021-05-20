//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import Resources

private let bubble = RoundedRectangle(cornerRadius: .corner(.big), style: .continuous)

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
                    .strokeBorder(lineWidth: lineWidth)
                    .foregroundColor(borderColor)
            )
            .clipShape(bubble)
    }
}

struct BubbleModifier: ViewModifier {
    
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                bubble
                    .foregroundColor(color)
            )
    }
}

struct GeometryEffectBubbleModifier: ViewModifier {
    let color: Color
    let id: String
    let namespace: Namespace.ID
    
    func body(content: Content) -> some View {
        content
            .clipShape(bubble)
            .background(
                bubble
                    .foregroundColor(color)
                    .matchedGeometryEffect(id: id, in: namespace)
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
    
    func bubbledMatched(color: Color = Asset.Colors.greenLightly.color.swiftuiColor, id: String, in namespace: Namespace.ID) -> some View {
        modifier(GeometryEffectBubbleModifier(color: color, id: id, namespace: namespace))
    }
}

