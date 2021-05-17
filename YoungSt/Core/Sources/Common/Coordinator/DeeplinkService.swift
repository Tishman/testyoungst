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
    case studentInvite(teacherID: UUID)
}

final class DeeplinkServiceImpl: DeeplinkService {
    
    enum Constants {
        static let scheme = "ygst"
        
        static let studentInvite = "student-invite"
        static let teacherID = "teacherID"
    }
    
    func transform(deeplinkURL: URL) -> Deeplink? {
        guard let scheme = deeplinkURL.scheme,
              scheme == Constants.scheme,
              let components = URLComponents(url: deeplinkURL, resolvingAgainstBaseURL: false)
              else { return nil }
        switch components.host {
        case Constants.studentInvite:
            guard let teacherID = components.queryItems?.first(where: { $0.name == Constants.teacherID })?.value,
                  let teacherUUID = UUID(uuidString: teacherID)
            else { return nil }
            return .studentInvite(teacherID: teacherUUID)
        default:
            return nil
        }
    }
    
    func transform(deeplink: Deeplink) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        switch deeplink {
        case let .studentInvite(teacherID):
            components.host = Constants.studentInvite
            components.queryItems = [.init(name: Constants.teacherID, value: teacherID.uuidString.lowercased())]
            return components.url!
        }
    }
    
}
