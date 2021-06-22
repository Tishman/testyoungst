//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.06.2021.
//

import SwiftUI

public struct ActionableEmptyPlaceholder: View {
    
    public init(imageSystemName: String, text: String, actionHandler: @escaping () -> Void) {
        self.imageSystemName = imageSystemName
        self.text = text
        self.actionHandler = actionHandler
    }
    
    private let imageSystemName: String
    private let text: String
    private let actionHandler: () -> Void
    
    public var body: some View {
        VStack {
            Button(action: actionHandler) {
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
            }
            .buttonStyle(InaccentButtonStyle())
            
            Text(text)
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .fixedSize()
        .frame(maxWidth: .infinity)
    }
}
