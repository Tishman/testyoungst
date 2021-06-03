//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import NetworkService
import Combine
import GRPC
import SwiftKeychainWrapper
import NIOHPACK
import Utilities
import Protocols

protocol AuthorizationService: AnyObject {
    func register(request: Authorization_RegistrationRequest) -> AnyPublisher<UUID, RegistrationError>
    func login(request: Authorization_LoginRequest) -> AnyPublisher<Authorization_LoginResponse, LoginError>
    func logout() -> AnyPublisher<Void, EquatableError>
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, EquatableError>
    func initResetPassword(request: Authorization_InitResetPasswordRequest) -> AnyPublisher<EmptyResponse, EquatableError>
    func checkResetPassword(request: Authorization_ResetPasswordCheckRequest) -> AnyPublisher<Bool, EquatableError>
    func resetPassword(request: Authorization_ResetPasswordRequest) -> AnyPublisher<EmptyResponse, EquatableError>
}

final class AuthorizationServiceImpl: AuthorizationService {
    
    private let client: Authorization_AuthorizationClient
    private let credentialsService: CredentialsService
    private let sessionKey = "session"
	private let userIdKey = "userId"
    
    init(client: Authorization_AuthorizationClient, credentialsService: CredentialsService) {
        self.client = client
        self.credentialsService = credentialsService
    }
	
    func register(request: Authorization_RegistrationRequest) -> AnyPublisher<UUID, RegistrationError> {
		let call = client.register(request)
		return call.response.publisher
			.map(\.userID)
			.tryMap(UUID.from)
			.catch { error -> AnyPublisher<UUID, RegistrationError> in
				let error = error as? BLError ?? .errUnknown
				guard error == .errVerificationNotConfirmedRegID
				else { return Result.failure(.default(error)).publisher.eraseToAnyPublisher() }
				return call.initialMetadata.publisher
					.tryMap(self.extractUserId)
					.mapError { .default($0 as? BLError ?? .errUnknown) }
					.flatMap { Result.failure(.errVerificationNotConfirmedRegID($0)).publisher }
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
    }
    
    func login(request: Authorization_LoginRequest) -> AnyPublisher<Authorization_LoginResponse, LoginError> {
        // TODO: Handle LoginError.errVerificationNotConfirmedRegID and extract user id for code confirming in metadata
        
        let call = client.login(request)
		
		return call.response.publisher
			.flatMap { Publishers.Zip(Just($0).setFailureType(to: Error.self), call.initialMetadata.publisher.tryMap(self.extractSession)) }
			.tryMap { response, sessionID in
				try (sessionID: sessionID,
					 userID: UUID.from(string: response.user.id),
					 response: response)
			}
			.handleEvents(receiveOutput: { [credentialsService] (sessionID, userID, response) in
				credentialsService.save(credentials: .init(userID: userID,
														   info: .init(nickname: response.user.login, email: response.user.email),
														   sessionID: sessionID))
			})
			.map { $0.2 }
			.catch { error -> AnyPublisher<Authorization_LoginResponse, LoginError> in
				if let error = error as? LoginError {
					return Result.failure(error).publisher.eraseToAnyPublisher()
				}
				let error = error as? BLError ?? .errUnknown
				guard error == .errVerificationNotConfirmedRegID
				else { return Result.failure(.default(error)).publisher.eraseToAnyPublisher() }
				return call.initialMetadata.publisher
					.tryMap(self.extractUserId)
					.mapError { .default($0 as? BLError ?? .errUnknown) }
					.flatMap { Result.failure(.errVerificationNotConfirmedRegID($0)).publisher }
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
    }
    
    private func extractSession(headers: HPACKHeaders) throws -> UUID {
        guard let session = headers[sessionKey].first,
              let sessionId = UUID(uuidString: session)
              else {
            throw LoginError.couldNotExtractSid
        }
        return sessionId
    }
	
	private func extractUserId(headers: HPACKHeaders) throws -> UUID {
		guard let user = headers[userIdKey].first,
			  let userId = UUID(uuidString: user)
		else {
			throw BLError.errUnknown
		}
		return userId
	}
    
    func logout() -> AnyPublisher<Void, EquatableError> {
        return client.logout(.init()).response.publisher
            .map(toVoid)
            .handleEvents(receiveOutput: credentialsService.clearCredentials)
			.mapError(EquatableError.init)
            .eraseToAnyPublisher()
    }
    
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, EquatableError> {
        return client.confirmCode(request).response.publisher
            .map(\.isConfirmed)
			.mapError(EquatableError.init)
            .eraseToAnyPublisher()
    }
    
    func initResetPassword(request: Authorization_InitResetPasswordRequest) -> AnyPublisher<EmptyResponse, EquatableError> {
        return client.initResetPassword(request).response.publisher
            .map(toEmpty)
			.mapError(EquatableError.init)
            .eraseToAnyPublisher()
    }
    
    func checkResetPassword(request: Authorization_ResetPasswordCheckRequest) -> AnyPublisher<Bool, EquatableError> {
        return client.checkRestPasswordCode(request).response.publisher
            .map(\.isSuccess)
			.mapError(EquatableError.init)
            .eraseToAnyPublisher()
    }
    
    func resetPassword(request: Authorization_ResetPasswordRequest) -> AnyPublisher<EmptyResponse, EquatableError> {
        return client.resetPassword(request).response.publisher
            .map(toEmpty)
			.mapError(EquatableError.init)
            .eraseToAnyPublisher()
    }
}
