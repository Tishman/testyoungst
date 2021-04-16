//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources

public struct RoundedStyle: ButtonStyle {
    public init(style: RoundedStyle.StyleType) {
        self.style = style
    }
    
    public enum StyleType {
        case filled
        case empty
        
        var textColor: Color {
            switch self {
            case .empty:
                return Asset.Colors.greenDark.color.swiftuiColor
            case .filled:
                return Asset.Colors.white.color.swiftuiColor
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .empty:
                return Asset.Colors.white.color.swiftuiColor
            case .filled:
                return Asset.Colors.greenDark.color.swiftuiColor
            }
        }
    }
    
    let style: StyleType
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .font(.body)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.4) : style.textColor)
            .bubbled(borderColor: style.textColor, foregroundColor: style.foregroundColor, lineWidth: 2)
    }
}

struct RoundedStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}, label: {
                Text("Button")
            })
            .buttonStyle(RoundedStyle(style: .filled))
            
            Button(action: {}, label: {
                Text("Button")
            })
            .buttonStyle(RoundedStyle(style: .empty))
        }
    }
}
