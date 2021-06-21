//
//  File.swift
//  
//
//  Created by Роман Тищенко on 05.05.2021.
//

import SwiftUI
import Resources
import Utilities

struct InputFieldModifier: ViewModifier {
    @Binding var focused: Bool
    var status: TextEditStatus
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
                .padding()
                .bubbled(borderColor: getBorderStyle(focused, status),
                         foregroundColor: status.foregroundColor,
                         lineWidth: focused ? 3 : 1)
                .cornerRadius(.corner(.big))
            statusMessage(status)
                .padding(.leading)
        }
    }
    
    private func statusMessage(_ status: TextEditStatus) -> some View {
        switch status {
        case let .success(value):
            return AnyView(Text(value)
                            .foregroundColor(.green)
                            .font(.subheadline))
        case let .error(value):
            return AnyView(Text(value)
                            .foregroundColor(.red)
                            .font(.subheadline))
        case .default:
            return AnyView(EmptyView())
        }
    }
    
    private func getBorderStyle(_ focused: Bool, _ status: TextEditStatus) -> Color {
        switch (focused, status) {
        case (true, .default):
            return Asset.Colors.greenDark.color.swiftuiColor
        case (true, .success):
            return .green
        case (true, .error):
            return .red
        case (false, _):
            return Asset.Colors.greenLightly.color.swiftuiColor
        }
    }
}

public extension View {
    func inputField(focused: Binding<Bool>, status: TextEditStatus) -> some View {
        modifier(InputFieldModifier(focused: focused, status: status))
    }
}

struct TextEditStyle: TextFieldStyle {
	@Binding var focused: Bool
	var status: TextEditStatus
	
	func _body(configuration: TextField<Self._Label>) -> some View {
		configuration
			.padding()
			.bubbled(borderColor: getBorderStyle(focused, status),
					 foregroundColor: status.foregroundColor,
					 lineWidth: focused ? 3 : 1)
			.cornerRadius(.corner(.big))
	}
	
	private func getBorderStyle(_ focused: Bool, _ status: TextEditStatus) -> Color {
		switch (focused, status) {
		case (true, .default):
			return Asset.Colors.greenDark.color.swiftuiColor
		case (true, .success):
			return .green
		case (true, .error):
			return .red
		case (false, _):
			return Asset.Colors.greenLightly.color.swiftuiColor
		}
	}
}
