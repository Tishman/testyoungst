//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import GRPC

enum ResetPasswordError: String, Error, GRPCInitable {
    case unknown
    case errVerificationNotFoundUser
    case errIncorrectResetPasswordCode
}

enum CheckResetPasswordError: String, Error, GRPCInitable {
    case unknown
    case errVerificationNotFoundUser
}

enum InitResetPasswordError: String, Error, GRPCInitable {
    case unknown
    case errVerificationNotFoundUser
}

enum RegistrationError: String, Error, GRPCInitable {
    case unknown
    case errUserAlreadyExists
}

enum LoginError: String, Error, GRPCInitable {
    case unknown
    case couldNotExtractSid
    case errVerificationNotConfirmedRegID
}

enum ConfrimCodeError: String, Error, GRPCInitable {
	case unknown
	case errIncorrectConfirmationCode
}

protocol GRPCInitable: RawRepresentable where RawValue == String {
    init(error: Error)
    
    static var unknown: Self { get }
}


extension GRPCInitable {
    init(error: Error) {
        if let selfErr = error as? Self {
            self = selfErr
            return
        }
        guard let grpc = error as? GRPCStatus else {
            self = .unknown
            return
        }
        
        self = grpc.message.flatMap(Self.init(rawValue:)) ?? .unknown
    }
}
