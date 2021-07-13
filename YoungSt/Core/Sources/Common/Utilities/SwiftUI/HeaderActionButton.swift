//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import SwiftUI
import Resources

public struct HeaderActionButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    public init(_ title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    private let minRowHeight = UIFloat(60)
    
    private let title: String
    private let systemImage: String
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity, minHeight: minRowHeight)
                .foregroundColor(Asset.Colors.greenDark.color.swiftuiColor)
        }
        .buttonStyle(defaultButtonStyle)
        .bubbled(color: Asset.Colors.greenDark.color.swiftuiColor.opacity(colorScheme == .light ? 0.15 : 0.4))
        .hoverEffectForIOS()
    }
    
}
