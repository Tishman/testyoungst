//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import SwiftUI

public struct HeaderActionButton: View {
    
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
        }
        .bubbled()
        .hoverEffect()
        .buttonStyle(DefaultButtonStyle())
    }
    
}
