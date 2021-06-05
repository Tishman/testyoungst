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
    private let defaults: UserDefaults = .standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    let sessionKey = "session"
    let userKey = "user"
    let userInfoKey = "userInfo"
    let profileInfoKey = "profileInfo"
    
    private let credentialsSubject: PassthroughSubject<Credentials?, Never> = .init()
    private let userInfoSubject: PassthroughSubject<UserInfo?, Never> = .init()
    
    var credentialsUpdated: AnyPublisher<Credentials?, Never> { credentialsSubject.eraseToAnyPublisher() }
    var profileUpdated: AnyPublisher<UserInfo?, Never> { userInfoSubject.eraseToAnyPublisher() }
    
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
    
    var currentUser: UserInfo? {
        guard let data = defaults.data(forKey: userInfoKey),
              let user = try? decoder.decode(UserInfo.self, from: data)
        else { return nil }
        return user
    }
    
    var currentProfile: CurrentProfileInfo? {
        defaults.data(forKey: profileInfoKey)
            .flatMap { try? decoder.decode(CurrentProfileInfo.self, from: $0) }
    }
    
    func save(credentials: Credentials) {
        keychain.set(credentials.sessionID.uuidString, forKey: sessionKey)
        keychain.set(credentials.userID.uuidString, forKey: userKey)
        
        credentialsSubject.send(credentials)
    }
    
    func save(profile: CurrentProfileInfo) {
        let info = try! encoder.encode(profile)
        defaults.set(info, forKey: profileInfoKey)
    }
    
    func save(userInfo: UserInfo) {
        let info = try! encoder.encode(userInfo)
        defaults.set(info, forKey: userInfoKey)
        
        userInfoSubject.send(userInfo)
    }
    
    func clearCredentials() {
        keychain.removeObject(forKey: sessionKey)
        keychain.removeObject(forKey: userKey)
        defaults.removeObject(forKey: userInfoKey)
        
        credentialsSubject.send(nil)
        userInfoSubject.send(nil)
    }
    
}
