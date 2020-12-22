//
//  NetworkError.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import Foundation

enum NetworkError: Error {
	case failedDataDecode
	
	var userInfo: String {
		switch self {
		case .failedDataDecode:
			return "Decoding data was failed."
		}
	}
}
