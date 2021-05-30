//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import GRPC
import NetworkService

enum RegistrationError: LocalizedError {
    case `default`(BLError)
	case errVerificationNotConfirmedRegID(UUID)
	
	var errorDescription: String? {
		switch self {
		case let .default(error):
			return error.errorDescription
		case .errVerificationNotConfirmedRegID:
			return BLError.errVerificationNotConfirmedRegID.errorDescription
		}
	}
}

enum LoginError: LocalizedError {
	case `default`(BLError)
    case couldNotExtractSid
    case errVerificationNotConfirmedRegID
	
	var errorDescription: String? {
		switch self {
		case let .default(error):
			return error.errorDescription
		case .couldNotExtractSid:
			return BLError.errInternal.errorDescription
		case .errVerificationNotConfirmedRegID:
			return BLError.errVerificationNotConfirmedRegID.errorDescription
		}
	}
}
