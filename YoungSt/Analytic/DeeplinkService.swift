//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import Coordinator
import Protocols
import FirebaseDynamicLinks

final class DeeplinkServiceImpl: DeeplinkService {
    
    enum Constants {
        static let scheme = "ygst"
        
        static let studentInvite = "invite"
        static let id = "id"
        static let password = "pwd"
    }
    
    func handle(customSchemeURL: URL) -> URL? {
        return DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: customSchemeURL)?.url
    }
    
    @discardableResult
    func handle(remoteLink: URL, handler: @escaping (URL?) -> Void) -> Bool {
        DynamicLinks.dynamicLinks().handleUniversalLink(remoteLink) { link, err in
            if let err = err {
                print(err)
            }
            if let url = link?.url {
                handler(url)
            } else {
                handler(nil)
            }
        }
    }
    
    func transform(deeplinkURL: URL) -> Deeplink? {
        guard let components = URLComponents(url: deeplinkURL, resolvingAgainstBaseURL: false)
              else { return nil }
        switch deeplinkURL.lastPathComponent {
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
