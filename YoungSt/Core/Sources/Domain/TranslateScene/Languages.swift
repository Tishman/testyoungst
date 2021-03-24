//
//  Languages.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import Foundation

public enum Languages: String {
	case english = "en"
	case russian = "ru"
	
	var viewModelValue: String {
		switch self {
		case .english:
			return "English"
		case .russian:
			return "Russian"
		}
	}
}
