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

public protocol UserProvider: AnyObject {
    var currentUser: UserInfo? { get }
    var currentUserID: UUID? { get }
}

