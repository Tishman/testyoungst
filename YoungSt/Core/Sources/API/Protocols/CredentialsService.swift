//
//  File.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import Combine

public protocol CredentialsService: AnyObject {
    
    var credentialsUpdated: AnyPublisher<Credentials?, Never> { get }
    var profileUpdated: AnyPublisher<UserInfo?, Never> { get }
    
    func save(credentials: Credentials)
    func save(profile: CurrentProfileInfo)
    func save(userInfo: UserInfo)
    
    func clearCredentials()
}

public struct Credentials: Hashable {
    public init(userID: UUID, sessionID: UUID) {
        self.userID = userID
        self.sessionID = sessionID
    }
    
    public let userID: UUID
    public let sessionID: UUID
}
