//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation

public protocol DeeplinkService: AnyObject {
    func transform(deeplinkURL: URL) -> Deeplink?
}

public enum Deeplink: Equatable {
    case studentInvite(teacherID: UUID)
}

final class DeeplinkServiceImpl: DeeplinkService {
    func transform(deeplinkURL: URL) -> Deeplink? {
        guard let scheme = deeplinkURL.scheme,
              scheme == "ygst",
              let components = URLComponents(url: deeplinkURL, resolvingAgainstBaseURL: false)
              else { return nil }
        switch components.host {
        case "student-invite":
            guard let teacherID = components.queryItems?.first(where: { $0.name == "teacherID" })?.value,
                  let teacherUUID = UUID(uuidString: teacherID)
            else { return nil }
            return .studentInvite(teacherID: teacherUUID)
        default:
            return nil
        }
    }
    
}
