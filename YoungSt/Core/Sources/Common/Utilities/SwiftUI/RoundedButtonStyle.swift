//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources

public struct RoundedButtonStyle: ButtonStyle {
    
    public static let minHeight: CGFloat = 64
    
	public init(style: RoundedButtonStyle.StyleType, isDisabled: Bool = false) {
        self.style = style
		self.isDisabled = isDisabled
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
	let isDisabled: Bool
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 200, minHeight: RoundedButtonStyle.minHeight)
			.font(Font.body.weight(.semibold))
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.4) : style.textColor)
			.bubbled(borderColor: style.textColor.opacity(isDisabled ? 0.4 : 1),
					 foregroundColor: style.foregroundColor.opacity(isDisabled ? 0.4 : 1),
					 lineWidth: 2)
    }
}

struct RoundedStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button(action: {}, label: {
                Text("Button")
            })
			.buttonStyle(RoundedButtonStyle(style: .filled, isDisabled: true))
            
            Button(action: {}, label: {
                Text("Button")
            })
			.buttonStyle(RoundedButtonStyle(style: .empty, isDisabled: false))
        }
    }
}
