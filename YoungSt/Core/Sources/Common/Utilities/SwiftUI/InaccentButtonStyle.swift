//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import SwiftUI
import Resources

public struct InaccentButtonStyle: ButtonStyle {
    
    public static let defaultSize: CGFloat = UIFloat(24)
    
    public init() {}
    
    private let accentColor = Asset.Colors.greenDark.color.swiftuiColor
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.spacing(.medium))
            .font(.body)
            .foregroundColor(configuration.isPressed ? accentColor.opacity(0.4) : accentColor)
            .bubbled()
    }
}

public struct PlainInaccentButtonStyle: ButtonStyle {
    public init() {}
    
    private let accentColor = Asset.Colors.greenDark.color.swiftuiColor
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.spacing(.medium))
            .font(.body)
            .foregroundColor(configuration.isPressed ? accentColor.opacity(0.4) : accentColor)
    }
}

public struct TintedButtonStyle: ButtonStyle {
    public init() {}
    
    private let accentColor = Asset.Colors.greenDark.color.swiftuiColor
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.spacing(.medium))
            .font(.body)
            .foregroundColor(configuration.isPressed ? accentColor.opacity(0.4) : accentColor)
            .bubbled(color: accentColor.opacity(0.1))
    }
}
