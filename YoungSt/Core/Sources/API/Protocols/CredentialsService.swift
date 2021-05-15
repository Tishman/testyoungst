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
    
    func save(credentials: Credentials)
    func save(profile: CurrentProfileInfo)
    
    func clearCredentials()
}

public struct Credentials: Hashable {
    public init(userID: UUID, info: UserInfo, sessionID: UUID) {
        self.userID = userID
        self.info = info
        self.sessionID = sessionID
    }
    
    public let userID: UUID
    public let info: UserInfo
    public let sessionID: UUID
}
