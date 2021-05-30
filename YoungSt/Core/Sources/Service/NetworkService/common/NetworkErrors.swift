//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import GRPC
import Foundation
import Resources

public enum BLError: String, LocalizedError, Equatable {
    case errUnknown
    case errConnectionIssue
    case errInternal
    case errVerificationNotFoundUser
    case errVerificationInvalidRegID
    case errVerificationNotConfirmedRegID
    case errVerificationRegIdNotExists
    case errInvalidCredentials
    case errUserAlreadyExists
    case errNicknameAlreadyTaken
    case errIncorrectResetPasswordCode
    case errInvalidFormat
    case errInvalidEmail
    case errInvalidLogin
    case errInvalidPassword
    case errIncorrectConfirmationCode
    case errLanguageNotSupported
    case errIncorrectRequest
    case errGroupNotFound
    case errWordNotFound
    case errNoAccess
    case errMetadataNotFound
    case errLocalesNotSet
    case errSessionNotProvided
    case errUserIdNotProvided
    case errNotFoundInviteAndRelation
    case errInviteNotFound
    case errTeacherEmpty
    case errInvalidFirstName
    case errInvalidLastName
    case errInvalidNickname
    case errNicknameAlreadyUsed
    case errProfileNotFound
    
    public var errorDescription: String? {
        switch self {
        case .errUnknown:
            return Loc.Errors.errUnknown
        case .errConnectionIssue:
            return Loc.Errors.errConnectionIssue
        case .errInternal:
            return Loc.Errors.errInternal
        case .errVerificationNotFoundUser:
            return Loc.Errors.errVerificationNotFoundUser
        case .errVerificationInvalidRegID:
            return Loc.Errors.errVerificationInvalidRegID
        case .errVerificationNotConfirmedRegID:
            return Loc.Errors.errVerificationNotConfirmedRegID
        case .errVerificationRegIdNotExists:
            return Loc.Errors.errVerificationRegIdNotExists
        case .errInvalidCredentials:
            return Loc.Errors.errInvalidCredentials
        case .errUserAlreadyExists:
            return Loc.Errors.errUserAlreadyExists
        case .errNicknameAlreadyTaken:
            return Loc.Errors.errNicknameAlreadyTaken
        case .errIncorrectResetPasswordCode:
            return Loc.Errors.errIncorrectResetPasswordCode
        case .errInvalidFormat:
            return Loc.Errors.errInvalidFormat
        case .errInvalidEmail:
            return Loc.Errors.errInvalidEmail
        case .errInvalidLogin:
            return Loc.Errors.errInvalidLogin
        case .errInvalidPassword:
            return Loc.Errors.errInvalidPassword
        case .errIncorrectConfirmationCode:
            return Loc.Errors.errIncorrectConfirmationCode
        case .errLanguageNotSupported:
            return Loc.Errors.errLanguageNotSupported
        case .errIncorrectRequest:
            return Loc.Errors.errIncorrectRequest
        case .errGroupNotFound:
            return Loc.Errors.errGroupNotFound
        case .errWordNotFound:
            return Loc.Errors.errWordNotFound
        case .errNoAccess:
            return Loc.Errors.errNoAccess
        case .errMetadataNotFound:
            return Loc.Errors.errMetadataNotFound
        case .errLocalesNotSet:
            return Loc.Errors.errLocalesNotSet
        case .errSessionNotProvided:
            return Loc.Errors.errSessionNotProvided
        case .errUserIdNotProvided:
            return Loc.Errors.errUserIdNotProvided
        case .errNotFoundInviteAndRelation:
            return Loc.Errors.errNotFoundInviteAndRelation
        case .errInviteNotFound:
            return Loc.Errors.errInviteNotFound
        case .errTeacherEmpty:
            return Loc.Errors.errTeacherEmpty
        case .errInvalidFirstName:
            return Loc.Errors.errInvalidFirstName
        case .errInvalidLastName:
            return Loc.Errors.errInvalidLastName
        case .errInvalidNickname:
            return Loc.Errors.errInvalidNickname
        case .errNicknameAlreadyUsed:
            return Loc.Errors.errNicknameAlreadyUsed
        case .errProfileNotFound:
            return Loc.Errors.errProfileNotFound
        }
    }
    
    public init(error: Error) {
        if let selfErr = error as? Self {
            self = selfErr
            return
        }
        guard let grpc = error as? GRPCStatus else {
            self = .errUnknown
            return
        }
        
        switch grpc.code {
        case .dataLoss, .deadlineExceeded, .resourceExhausted, .unavailable:
            self = .errConnectionIssue
        default:
            self = grpc.message.flatMap(Self.init(rawValue:)) ?? .errUnknown
        }
    }
}
