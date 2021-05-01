//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import Protocols
import SwiftKeychainWrapper

protocol CredentialsService: AnyObject {
    func save(session: UUID)
    func save(userID: UUID)
    func clearCredentials()
}

final class CredentialsServiceImpl: CredentialsService, UserProvider, SessionProvider {
    
    private let keychain: KeychainWrapper = .standard
    let sessionKey = "session"
    let userKey = "user"
    
    var currentSid: UUID? {
        return .init(uuidString: "0e38b43a-18da-47b3-b7d3-6c0d49e98d01")!
        
        guard let stringSid = keychain.string(forKey: sessionKey),
            let id = UUID(uuidString: stringSid)
        else { return nil }
        return id
    }
    
    var currentUserID: UUID? {
        return .init(uuidString: "031a71c3-dca2-44f6-bb2d-022b4a9473b2")!
        
        guard let stringId = keychain.string(forKey: userKey),
              let id = UUID(uuidString: stringId)
        else { return nil }
        return id
    }
    
    func save(session: UUID) {
        keychain.set(session.uuidString, forKey: sessionKey)
    }
    
    func save(userID: UUID) {
        keychain.set(userID.uuidString, forKey: userKey)
    }
    
    func clearCredentials() {
        keychain.removeObject(forKey: sessionKey)
        keychain.removeObject(forKey: userKey)
    }
    
}
