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
            CloseShape()
                .stroke(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .foregroundColor(Asset.Colors.secondaryAccentContent.color.swiftuiColor)
                .padding(10)
                .background(
                    Asset.Colors.secondaryAccentBackground.color.swiftuiColor
                )
                .clipShape(Circle())
        }
        .frame(width: DefaultSize.navigationBarButton,
               height: DefaultSize.navigationBarButton)
    }
}

struct CloseShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: .zero)
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            path.move(to: .init(x: rect.maxX, y: 0))
            path.addLine(to: .init(x: 0, y: rect.maxY))
        }
    }
    
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton {}
            
    }
}
