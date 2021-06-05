//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation

public protocol DeeplinkService: AnyObject {
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

final class DeeplinkServiceImpl: DeeplinkService {
    
    enum Constants {
        static let scheme = "ygst"
        
        static let studentInvite = "invite"
        static let id = "id"
        static let password = "pwd"
    }
    
    func transform(deeplinkURL: URL) -> Deeplink? {
        guard let scheme = deeplinkURL.scheme,
              scheme == Constants.scheme,
              let components = URLComponents(url: deeplinkURL, resolvingAgainstBaseURL: false)
              else { return nil }
        switch components.host {
        case Constants.studentInvite:
            guard let idString = components.queryItems?.first(where: { $0.name == Constants.id })?.value,
                  let id = Int(idString),
                  let password = components.queryItems?.first(where: { $0.name == Constants.password })?.value
            else { return nil }
            let invite = SharedInvite(id: id, password: password)
            return .studentInvite(invite)
        default:
            return nil
        }
    }
    
    func transform(deeplink: Deeplink) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        switch deeplink {
        case let .studentInvite(invite):
            components.host = Constants.studentInvite
            components.queryItems = [.init(name: Constants.id, value: "\(invite.id)"),
                                     .init(name: Constants.password, value: "\(invite.password)")]
            return components.url!
        }
    }
    
}
