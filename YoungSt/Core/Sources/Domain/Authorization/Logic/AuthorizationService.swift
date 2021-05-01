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
    func logout() -> AnyPublisher<Void, Error>
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, ConfrimCodeError>
    func initResetPassword(request: Authorization_InitResetPasswordRequest) -> AnyPublisher<Void, InitResetPasswordError>
    func checkResetPassword(request: Authorization_ResetPasswordCheckRequest) -> AnyPublisher<Bool, CheckResetPasswordError>
    func resetPassword(request: Authorization_ResetPasswordRequest) -> AnyPublisher<Void, ResetPasswordError>
}

final class AuthorizationServiceImpl: AuthorizationService {
    
    private let client: Authorization_AuthorizationClient
    private let credentialsService: CredentialsService
    private let sessionKey = "session"
    
    init(client: Authorization_AuthorizationClient, credentialsService: CredentialsService) {
        self.client = client
        self.credentialsService = credentialsService
    }
    
    func register(request: Authorization_RegistrationRequest) -> AnyPublisher<UUID, RegistrationError> {
        return client.register(request).response.publisher
            .map(\.userID)
            .tryMap(UUID.from)
            .mapError(RegistrationError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func login(request: Authorization_LoginRequest) -> AnyPublisher<Authorization_LoginResponse, LoginError> {
        // TODO: Handle LoginError.errVerificationNotConfirmedRegID and extract user id for code confirming in metadata
        
        let call = client.login(request)
        let loginAndSaveSid = call.initialMetadata.publisher
            .flatMap(extractSession)
            .handleEvents(receiveOutput: saveSession(id:))
            .eraseToAnyPublisher()
        let extractResponse = call.response.publisher
            .tryMap(saveUserID)
        
        return loginAndSaveSid
            .map(toVoid)
            .flatMap { extractResponse }
            .mapError(LoginError.init(error:))
            .eraseToAnyPublisher()
    }
    
    private func saveUserID(response: Authorization_LoginResponse) throws -> Authorization_LoginResponse {
        let user = try UUID.from(string: response.user.id)
        credentialsService.save(userID: user)
        return response
    }
    
    private func extractSession(headers: HPACKHeaders) -> AnyPublisher<UUID, Error> {
        guard let session = headers[sessionKey].first,
              let sessionId = UUID(uuidString: session)
              else {
            return Result.failure(LoginError.couldNotExtractSid).publisher.eraseToAnyPublisher()
        }
        return Result.success(sessionId).publisher.eraseToAnyPublisher()
    }
    
    private func saveSession(id: UUID) {
        credentialsService.save(session: id)
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return client.logout(.init()).response.publisher
            .map(toVoid)
            .handleEvents(receiveOutput: credentialsService.clearCredentials)
            .eraseToAnyPublisher()
    }
    
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, ConfrimCodeError> {
        return client.confirmCode(request).response.publisher
            .map(\.isConfirmed)
			.mapError(ConfrimCodeError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func initResetPassword(request: Authorization_InitResetPasswordRequest) -> AnyPublisher<Void, InitResetPasswordError> {
        return client.initResetPassword(request).response.publisher
            .map(toVoid)
            .mapError(InitResetPasswordError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func checkResetPassword(request: Authorization_ResetPasswordCheckRequest) -> AnyPublisher<Bool, CheckResetPasswordError> {
        return client.checkRestPasswordCode(request).response.publisher
            .map(\.isSuccess)
            .mapError(CheckResetPasswordError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func resetPassword(request: Authorization_ResetPasswordRequest) -> AnyPublisher<Void, ResetPasswordError> {
        return client.resetPassword(request).response.publisher
            .map(toVoid)
            .mapError(ResetPasswordError.init(error:))
            .eraseToAnyPublisher()
    }
}
