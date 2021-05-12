//
//  File.swift
//  
//
//  Created by Nikita Patskov on 11.05.2021.
//

import Foundation
import SwiftUI
import Utilities
import Resources

struct DeleteModifier<ID: Hashable>: ViewModifier {
    
    let action: () -> Bool
    let identifier: ID
    @Binding var openedIdentifier: ID?
    
    private struct ItemWidth: Preference {
        typealias Value = CGFloat
    }
    
    private let buttonPadding: CGFloat = .spacing(.ultraSmall)
    
    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    @State private var willDeleteIfReleased = false
    @State private var contentWidth: CGFloat = 0.0
    private let contentWidthReader = GeometryPreferenceReader(key: AppendValue<ItemWidth>.self) { [$0.size.width] }
   
    func body(content: Content) -> some View {
        content
            .read(contentWidthReader)
            .fetchReaded(contentWidthReader) { contentWidth = $0.max() ?? 0 }
            .background(
                Button(action: delete) {
                    HStack(spacing: 0) {
                        VStack(spacing: .spacing(.small)) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                .layoutPriority(-1)
                            
                            Text(Localizable.delete)
                                .foregroundColor(.white)
                                .font(.system(size: 11).bold())
                        }
                        .fixedSize()
                        .padding(.horizontal, .spacing(.medium))
                        
                        if willDeleteIfReleased {
                            Spacer()
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .frame(width: max(-offset.width, 0))
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: .corner(.big)))
                .offset(x: (contentWidth-offset.width) / 2 + buttonPadding)
            )
            .offset(x: offset.width, y: 0)
            .animation(.interactiveSpring(response: 0.25), value: offset)
            .onChange(of: openedIdentifier) { newValue in
                if newValue != identifier {
                    closeSwap()
                }
            }
            .highPriorityGesture (
                DragGesture()
                    .onChanged { gesture in
                        openedIdentifier = identifier
                        if gesture.translation.width + initialOffset.width <= 0 {
                            self.offset.width = gesture.translation.width + initialOffset.width
                        } else {
                            self.offset.width = (gesture.translation.width + initialOffset.width) / 4
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                    }
                    .onEnded { _ in
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            openedIdentifier = nil
                            closeSwap()
                        }
                    }
            )
    }
    
    private func closeSwap() {
        offset = .zero
        initialOffset = .zero
    }
    
    private func delete() {
        let shouldSwipeToTheEnd = action()
        offset.width = shouldSwipeToTheEnd ? -contentWidth : 0
        if !shouldSwipeToTheEnd {
            openedIdentifier = nil
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    //MARK: Constants
    
    let deletionDistance = CGFloat(200)
    let halfDeletionDistance = CGFloat(50)
    let tappableDeletionWidth = CGFloat(100)
    
    
}

extension View {
    
    func onDelete<ID: Hashable>(tag: ID, selection: Binding<ID?>, perform action: @escaping () -> Bool) -> some View {
        modifier(DeleteModifier(action: action, identifier: tag, openedIdentifier: selection))
    }
}
