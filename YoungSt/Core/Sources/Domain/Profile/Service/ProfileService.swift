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

protocol ProfileService: AnyObject {
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error>

    func getOwnProfileInfo(request: Profile_GetOwnProfileInfoRequest) -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error>

    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error>
}

struct ProfileInfo: Identifiable, Hashable {
    let id: UUID
    let nickname: String
    let email: String
    let firstName: String
    let lastName: String
    
    var displayName: String {
        if !firstName.isEmpty {
            return [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
        } else if !nickname.isEmpty {
            return "@\(nickname)"
        } else if !email.isEmpty {
            return email
        } else {
            // Should never happen
            return "Empty"
        }
    }
    
    var secondaryDisplayName: String {
        if !nickname.isEmpty {
            return "@\(nickname)"
        }
        return email
    }
}

extension ProfileInfo {
    init(proto: Profile_ProfileInfo) throws {
        try self.init(id: .from(string: proto.id),
                      nickname: proto.nickname,
                      email: proto.email,
                      firstName: proto.firstName,
                      lastName: proto.lastName)
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
        credentialsService.save(profile: info)
    }
    
    func getOwnProfileInfo(request: Profile_GetOwnProfileInfoRequest) -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error> {
        return client.getOwnProfileInfo(request).response.publisher
            .handleEvents(receiveOutput: { self.saveOwnProfile(profileInfo: $0.profile) })
            .eraseToAnyPublisher()
    }
    
    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error> {
        return client.updateProfile(request).response.publisher
            .handleEvents(receiveOutput: { self.saveOwnProfile(profileInfo: $0.profile) })
            .eraseToAnyPublisher()
    }
}
