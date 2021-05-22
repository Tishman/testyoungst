//
//  File.swift
//  
//
//  Created by Роман Тищенко on 05.05.2021.
//

import SwiftUI
import Resources

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
