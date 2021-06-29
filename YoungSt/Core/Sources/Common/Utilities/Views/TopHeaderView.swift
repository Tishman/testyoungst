//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import SwiftUI
import Resources
import Introspect

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


public extension View {
	
	/// Use TrackableScrollView for getting content offset and topHidden bool variable to determine top navigation visibility
	/// - Parameters:
	///   - contentOffset: scrollView content offset
	///   - topHidden: boolean flag for opaque determinatio
	///   - requiredOffset: required offset to show topHidden
	
	func makeCustomBarManagement(offset contentOffset: CGFloat, topHidden: Binding<Bool>, requiredOffset: CGFloat = 0) -> some View {
        self.onChange(of: contentOffset) { newOffset in
            if newOffset > requiredOffset && topHidden.wrappedValue {
                withAnimation(.linear(duration: 0.2)) {
                    topHidden.wrappedValue = false
                }
            } else if newOffset <= requiredOffset && !topHidden.wrappedValue {
                withAnimation(.linear(duration: 0.15)) {
                    topHidden.wrappedValue = true
                }
            }
        }
        .makeDefaultNavigationBarTransparent()
    }
    
    func makeDefaultNavigationBarTransparent() -> some View {
        self.introspectNavigationController {
            $0.navigationBar.backgroundColor = .clear
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
            $0.navigationBar.shadowImage = UIImage()
        }
    }
    
}
