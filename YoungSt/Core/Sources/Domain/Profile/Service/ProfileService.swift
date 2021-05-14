//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import NetworkService
import Combine

protocol ProfileService: AnyObject {
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error>

    func getOwnProfileInfo(request: Profile_GetOwnProfileInfoRequest) -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error>

    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error>
}

final class ProfileServiceImpl: ProfileService {
    
    private let client: Profile_ProfileClientProtocol
    
    init(client: Profile_ProfileClientProtocol) {
        self.client = client
    }
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error> {
        return client.getProfileInfo(request).response.publisher
            .eraseToAnyPublisher()
    }
    
    func getOwnProfileInfo(request: Profile_GetOwnProfileInfoRequest) -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error> {
        return client.getOwnProfileInfo(request).response.publisher
            .eraseToAnyPublisher()
    }
    
    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error> {
        return client.updateProfile(request).response.publisher
            .eraseToAnyPublisher()
    }
}
