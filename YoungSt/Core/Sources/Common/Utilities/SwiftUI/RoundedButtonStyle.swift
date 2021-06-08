//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources

public struct RoundedButtonStyle: ButtonStyle {
    
    public static let minHeight: CGFloat = UIFloat(64)
    private static let minHeightCompact = UIFloat(44)
    
    public init(style: RoundedButtonStyle.StyleType, isLoading: Bool = false) {
        self.style = style
        self.isLoading = isLoading
        self._keyboardVisible = .init(initialValue: KeyboardObserver.shared.isKeyboardVisible)
    }
    
    public enum StyleType {
        case filled
        case empty
        
        var textColor: Color {
            switch self {
            case .empty:
                return Asset.Colors.greenDark.color.swiftuiColor
            case .filled:
                return Asset.Colors.white.color.swiftuiColor
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .empty:
                return Asset.Colors.white.color.swiftuiColor
            case .filled:
                return Asset.Colors.greenDark.color.swiftuiColor
            }
        }
        
        var borderColor: Color {
            switch self {
            case .empty:
                return Asset.Colors.greenDark.color.swiftuiColor
            case .filled:
                return .clear
            }
        }
    }
    
    let style: StyleType
    let isLoading: Bool
    
    @State private var keyboardVisible = false
    @Environment(\.isEnabled) private var isEnabled
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        // ZStack for proper content identity
        ZStack {
            content(configuration: configuration)
        }
        .bubbled(borderColor: style.borderColor.opacity(isEnabled ? 1 : 0.4),
                 foregroundColor: style.foregroundColor.opacity(isEnabled ? 1 : 0.4),
                 lineWidth: 2)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isLoading)
        .frame(maxWidth: keyboardVisible ? .infinity : nil, alignment: .trailing)
        .padding(.horizontal)
        .onReceive(KeyboardObserver.shared.keyboardVisibilityChangedPublisher) { notification in
            withAnimation(.easeOut(duration: notification.animationProperties.duration)) {
                keyboardVisible = notification.isKeyboardVisible
            }
        }
    }
    
    @ViewBuilder private func content(configuration: Self.Configuration) -> some View {
        if isLoading {
            PlainIndicatorView(color: style == .filled ? .white : Asset.Colors.loaderContent.color.swiftuiColor,
                               size: RoundedButtonStyle.minHeight,
                               paddingValue: .spacing(.regular))
        } else {
            configuration.label
                .padding()
                .frame(minWidth: UIFloat(keyboardVisible ? 150 : 200),
                       minHeight: keyboardVisible ? RoundedButtonStyle.minHeightCompact : RoundedButtonStyle.minHeight)
                .font(.body.weight(.semibold))
                .foregroundColor(style.textColor.opacity(configuration.isPressed ? 0.4 : 1))
        }
    }
}

struct TestButtonView: View {
    
    @State var isLoading = false
    
    let style: RoundedButtonStyle.StyleType
    
    var body: some View {
        Button(action: { isLoading.toggle() }, label: {
            Text("Button")
        })
        .buttonStyle(RoundedButtonStyle(style: style, isLoading: isLoading))
    }
    
}

struct RoundedStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TestButtonView(style: .filled)
            TestButtonView(style: .empty)
        }
    }
}
