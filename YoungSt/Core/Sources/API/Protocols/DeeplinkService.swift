//
//  File.swift
//  
//
//  Created by Nikita Patskov on 25.06.2021.
//

import Foundation

public protocol DeeplinkService: AnyObject {
    
    func handle(customSchemeURL: URL) -> URL?
    
    @discardableResult
    func handle(remoteLink: URL, handler: @escaping (URL?) -> Void) -> Bool
    
    func transform(deeplinkURL: URL) -> Deeplink?
    
    func transform(deeplink: Deeplink) -> URL
}

public enum Deeplink: Equatable {
    case studentInvite(SharedInvite)
}

public struct SharedInvite: Equatable {
    public init(id: Int, password: String) {
        self.id = id
        self.password = password
    }
    
    public let id: Int
    public let password: String
}
