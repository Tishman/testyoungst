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
    
    public init(_ title: String, systemImage: String, imageScale: Image.Scale = .medium, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.imageScale = imageScale
        self.action = action
    }
    
    private let minRowHeight = UIFloat(60)
    
    private let title: String
    private let systemImage: String
    private let imageScale: Image.Scale
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Label(title: { Text(title) }) {
                Image(systemName: systemImage)
                    .imageScale(imageScale)
            }
            .frame(maxWidth: .infinity, minHeight: minRowHeight)
            .foregroundColor(Asset.Colors.greenDark.color.swiftuiColor)
        }
        .buttonStyle(defaultButtonStyle)
        .bubbled(color: Asset.Colors.greenDark.color.swiftuiColor.opacity(colorScheme == .light ? 0.15 : 0.4))
        .hoverEffectForIOS()
    }
    
}
