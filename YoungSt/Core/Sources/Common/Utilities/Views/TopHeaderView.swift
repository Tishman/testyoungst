//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import SwiftUI
import Resources

public struct TopHeaderView: View {
    
    public init(width: CGFloat, topSafeAreaInset: CGFloat) {
        self.width = width
        self.topSafeAreaInset = topSafeAreaInset
    }
    
    
    private let width: CGFloat
    private let topSafeAreaInset: CGFloat
    
    public var body: some View {
        BlurEffect(style: .systemThickMaterial)
            .frame(height: topSafeAreaInset)
            .overlay(
                VStack {
                    Spacer()
                    Divider()
                }
            )
            .edgesIgnoringSafeArea(.all)
            .position(x: width / 2, y: 0)
    }
}

