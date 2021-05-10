//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import Protocols
import SwiftKeychainWrapper
import Combine

final class CredentialsServiceImpl: CredentialsService, UserProvider, SessionProvider {
    
    private let keychain: KeychainWrapper = .standard
    let sessionKey = "session"
    let userKey = "user"
    
    let credentialsSubject: PassthroughSubject<Credentials?, Never> = .init()
    var credentialsUpdated: AnyPublisher<Credentials?, Never> { credentialsSubject.eraseToAnyPublisher() }
    
    var currentSid: UUID? {
        guard let stringSid = keychain.string(forKey: sessionKey),
            let id = UUID(uuidString: stringSid)
        else { return nil }
        return id
    }
    
    var currentUserID: UUID? {
        guard let stringId = keychain.string(forKey: userKey),
              let id = UUID(uuidString: stringId)
        else { return nil }
        return id
    }
    
    func save(credentials: Credentials) {
        keychain.set(credentials.sessionID.uuidString, forKey: sessionKey)
        keychain.set(credentials.userID.uuidString, forKey: userKey)
        
        credentialsSubject.send(credentials)
    }
    
    func clearCredentials() {
        keychain.removeObject(forKey: sessionKey)
        keychain.removeObject(forKey: userKey)
        
        credentialsSubject.send(nil)
    }
    
}
