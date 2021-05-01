//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import SwiftUI

private struct OffsetPreference: Preference {
    typealias Value = CGFloat
}

public struct TrackableScrollView<Content: View>: View {
    
    private let axes: Axis.Set
    private let showIndicators: Bool
    @Binding private var contentOffset: CGFloat
    private let content: Content
    
    /// Creates a new instance that’s scrollable in the direction of the given axis and can show indicators while scrolling.
    /// - Parameters:
    ///   - axes: The scrollable axes of the scroll view.
    ///   - showIndicators: A value that indicates whether the scroll view displays the scrollable component of the content offset, in a way that’s suitable for the platform.
    ///   - contentOffset: A value that indicates  offset of content.
    ///   - content: The scroll view’s content.
    public init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        _contentOffset = contentOffset
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: AppendValue<OffsetPreference>.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                    }
                    VStack(spacing: 0) {
                        self.content
                    }
                }
            }
        }
        .onPreferenceChange(AppendValue<OffsetPreference>.self) { self.contentOffset = $0.last ?? 0 }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            #if !targetEnvironment(macCatalyst) && os(macOS)
            return -(outsideProxy.frame(in: .global).maxY - insideProxy.frame(in: .global).maxY + outsideProxy.safeAreaInsets.top)
            #else
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
            #endif
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}
