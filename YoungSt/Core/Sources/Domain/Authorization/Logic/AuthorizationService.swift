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

protocol AuthorizationService: AnyObject {
    func register(request: Authorization_RegistrationRequest) -> AnyPublisher<UUID, RegistrationError>
    func login(request: Authorization_LoginRequest) -> AnyPublisher<Authorization_LoginResponse, LoginError>
    func logout() -> AnyPublisher<Void, Error>
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, Error>
    func initResetPassword(request: Authorization_InitResetPasswordRequest) -> AnyPublisher<Void, InitResetPasswordError>
    func checkResetPassword(request: Authorization_ResetPasswordCheckRequest) -> AnyPublisher<Bool, CheckResetPasswordError>
    func resetPassword(request: Authorization_ResetPasswordRequest) -> AnyPublisher<Void, ResetPasswordError>
    
    func getCurrentSid() -> UUID?
}

func toVoid<T>(_ any: T) -> Void {}

final class AuthorizationServiceImpl: AuthorizationService {
    
    private let client: Authorization_AuthorizationClient
    private let keychain: KeychainWrapper = .standard
    private let sessionKey = "session"
    
    init(client: Authorization_AuthorizationClient) {
        self.client = client
    }
    
    func getCurrentSid() -> UUID? {
        guard let stringSid = keychain.string(forKey: sessionKey),
            let id = UUID(uuidString: stringSid)
        else { return nil }
        return id
    }
    
    func register(request: Authorization_RegistrationRequest) -> AnyPublisher<UUID, RegistrationError> {
        // TODO: Handle userId setting
        
        return client.register(request).response.publisher
            .map(\.userID)
            .tryMap(UUID.from)
            .mapError(RegistrationError.init(error:))
            .eraseToAnyPublisher()
    }
    
    func login(request: Authorization_LoginRequest) -> AnyPublisher<Authorization_LoginResponse, LoginError> {
        
        let call = client.login(request)
        let loginAndSaveSid = call.initialMetadata.publisher
            .flatMap(extractSession)
            .handleEvents(receiveOutput: saveSession(id:))
            .eraseToAnyPublisher()
        let extractResponse = call.response.publisher
        
        return loginAndSaveSid
            .map(toVoid)
            .flatMap { extractResponse }
            .mapError(LoginError.init(error:))
            .eraseToAnyPublisher()
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
        keychain.set(id.uuidString, forKey: sessionKey)
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        return client.logout(.init()).response.publisher
            .map(toVoid)
            .eraseToAnyPublisher()
    }
    
    func confirmCode(request: Authorization_ConfirmCodeRequest) -> AnyPublisher<Bool, Error> {
        return client.confirmCode(request).response.publisher
            .map(\.isConfirmed)
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
