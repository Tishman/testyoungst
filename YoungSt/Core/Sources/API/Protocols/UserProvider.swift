//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation

public struct UserInfo: Hashable, Codable {
    public init(nickname: String, email: String) {
        self.nickname = nickname
        self.email = email
    }
    
    public let nickname: String
    public let email: String
}

public struct CurrentProfileInfo: Hashable, Codable {
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    public let firstName: String
    public let lastName: String
}

public protocol UserProvider: AnyObject {
    var currentUser: UserInfo? { get }
    var currentProfile: CurrentProfileInfo? { get }
    var currentUserID: UUID? { get }
}

