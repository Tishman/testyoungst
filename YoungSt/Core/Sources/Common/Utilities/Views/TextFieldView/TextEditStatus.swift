//
//  File.swift
//  
//
//  Created by Роман Тищенко on 05.05.2021.
//

import SwiftUI
import Resources

public enum TextEditStatus: Equatable {
	case error(String)
	case success(String)
	case `default`
	
	public var foregroundColor: Color {
		switch self {
		case .default:
			return Asset.Colors.greenLightly.color.swiftuiColor
		case .success:
			return Asset.Colors.greenLight.color.swiftuiColor
		case .error:
			return Asset.Colors.pink.color.swiftuiColor
		}
	}
	
	public var iconColor: Color {
		switch self {
		case .default:
			return Asset.Colors.greenDark.color.swiftuiColor
		case .success:
			return .green
		case .error:
			return .red
		}
	}
}
