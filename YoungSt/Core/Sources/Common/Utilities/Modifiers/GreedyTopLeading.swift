//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI

public struct GreedyModifier: ViewModifier {
    
    let alignment: Alignment
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
}

public extension View {
    
    func greedy(_ alignment: Alignment) -> some View {
        modifier(GreedyModifier(alignment: alignment))
    }
    
}
