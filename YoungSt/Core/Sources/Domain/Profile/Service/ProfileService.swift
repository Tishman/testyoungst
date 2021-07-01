//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import NetworkService
import Combine
import Protocols
import Utilities

protocol ProfileService: AnyObject {
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error>

    func getOwnProfileInfo() -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error>

    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error>
    
    func searchUsers(request: Profile_SearchUsersRequest) -> AnyPublisher<Profile_SearchUsersResponse, Error>
}

struct ProfileInfo: Identifiable, Hashable {
    let id: UUID
    let displayName: DisplayName
    
    var primaryField: String {
        switch displayName {
        case let .one(text), let .two(text, _), let .three(text, _, _):
            return text
        }
    }
    
    var secondaryField: String {
        switch displayName {
        case let .two(_, text), let .three(_, text, _):
            return text
        default:
            return ""
        }
    }
    
    var tertiaryField: String {
        switch displayName {
        case let .three(_, _, text):
            return text
        default:
            return ""
        }
    }
    
    enum DisplayName: Hashable {
        case one(String)
        case two(primary: String, secondary: String)
        case three(primary: String, secondary: String, tertiary: String)
    }
}

extension ProfileInfo: Previwable {
    static let preview: Self = .init(id: .init(),
                                     displayName: .three(primary: "Max Rakotanski",
                                                         secondary: "@mrakotanski",
                                                         tertiary: "mrakotanski@apple.com"))
}

extension ProfileInfo {
    init(proto: Profile_ProfileInfo) throws {
        let displayName: DisplayName
        var fields: [String] = []
        if !proto.firstName.isEmpty {
            if !proto.lastName.isEmpty {
                fields.append("\(proto.firstName) \(proto.lastName)")
            } else {
                fields.append(proto.firstName)
            }
        }
        if !proto.nickname.isEmpty {
            fields.append(proto.nickname)
        }
        if !proto.email.isEmpty {
            fields.append(proto.email)
        }
        
        switch fields.count {
        case 0:
            displayName = .one("Empty")
        case 1:
            displayName = .one(fields[0])
        case 2:
            displayName = .two(primary: fields[0], secondary: fields[1])
        default:
            displayName = .three(primary: fields[0], secondary: fields[1], tertiary: fields[2])
        }
        
        try self.init(id: .from(string: proto.id),
                      displayName: displayName)
    }
}

final class ProfileServiceImpl: ProfileService {
    
    private let client: Profile_ProfileClientProtocol
    private let credentialsService: CredentialsService
    
    init(client: Profile_ProfileClientProtocol, credentialsService: CredentialsService) {
        self.client = client
        self.credentialsService = credentialsService
    }
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error> {
        return client.getProfileInfo(request).response.publisher
            .eraseToAnyPublisher()
    }
    
    private func saveOwnProfile(profileInfo: Profile_ProfileInfo) {
        let info = CurrentProfileInfo(firstName: profileInfo.firstName, lastName: profileInfo.lastName)
        let userInfo = UserInfo(nickname: profileInfo.nickname, email: profileInfo.email)
        
        credentialsService.save(profile: info)
        credentialsService.save(userInfo: userInfo)
    }
    
    func getOwnProfileInfo() -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error> {
        return client.getOwnProfileInfo(.init()).response.publisher
            .handleEvents(receiveOutput: { self.saveOwnProfile(profileInfo: $0.profile) })
            .eraseToAnyPublisher()
    }
    
    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error> {
        return client.updateProfile(request).response.publisher
            .handleEvents(receiveOutput: { self.saveOwnProfile(profileInfo: $0.profile) })
            .eraseToAnyPublisher()
    }
    
    func searchUsers(request: Profile_SearchUsersRequest) -> AnyPublisher<Profile_SearchUsersResponse, Error> {
        return client.searchUsers(request).response.publisher
            .eraseToAnyPublisher()
    }
}
