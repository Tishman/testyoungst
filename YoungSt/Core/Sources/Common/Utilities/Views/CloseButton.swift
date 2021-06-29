//
//  File.swift
//  
//
//  Created by Nikita Patskov on 30.04.2021.
//

import SwiftUI
import Resources

public struct CloseButton: View {
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            CrossView()
        }
        .buttonStyle(defaultButtonStyle)
        .frame(width: DefaultSize.navigationBarButton, height: DefaultSize.navigationBarButton)
    }
}

public struct CrossView: View {
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            CloseShape()
                .stroke(style: .init(lineWidth: min(proxy.size.width, proxy.size.height) / 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(Asset.Colors.secondaryAccentContent.color.swiftuiColor)
                .background(
                    Asset.Colors.secondaryAccentBackground.color.swiftuiColor
                )
                .clipShape(Circle())
        }
    }
}

struct CloseShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let side = min(rect.size.width, rect.size.height)
            let opposite = max(rect.size.width, rect.size.height)
            let shift = side / 3
            
            if rect.size.width < rect.size.height {
                path.move(to: .init(x: shift, y: (opposite - side) / 2 + shift))
                path.addLine(to: .init(x: rect.maxX - shift, y: (opposite + side) / 2 - shift))
                path.move(to: .init(x: rect.maxX - shift, y: (opposite - side) / 2 + shift))
                path.addLine(to: .init(x: shift, y: (opposite + side) / 2 - shift))
            } else {
                path.move(to: .init(x: (opposite - side) / 2 + shift, y: shift))
                path.addLine(to: .init(x: (opposite + side) / 2 - shift, y: rect.maxY - shift))
                path.move(to: .init(x: (opposite - side) / 2 + shift, y: rect.maxY - shift))
                path.addLine(to: .init(x: (opposite + side) / 2 - shift, y: shift))
            }
        }
    }
    
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton {}
            
    }
}
