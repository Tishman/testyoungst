//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import Combine
import NetworkService

protocol InviteService: AnyObject {
    func getTeacher() -> AnyPublisher<Profile_GetTeacherResponse, Error>
    func removeTeacher(request: Profile_RemoveTeacherRequest) -> AnyPublisher<EmptyResponse, Error>
    func sendInviteToTeacher(request: Profile_SendInviteToTeacherRequest) -> AnyPublisher<EmptyResponse, Error>
    func sendInviteToStudent(request: Profile_SendInviteToStudentRequest) -> AnyPublisher<EmptyResponse, Error>
    func acceptInvite(request: Profile_AcceptInviteRequest) -> AnyPublisher<EmptyResponse, Error>
    func rejectInvite(request: Profile_RejectInviteRequest) -> AnyPublisher<EmptyResponse, Error>
    func getSharedInviteInfo(request: Profile_GetSharedInviteInfoRequest) -> AnyPublisher<Profile_GetSharedInviteInfoResponse, Error>
    func acceptSharedTeacherInvite(request: Profile_AcceptSharedTeacherInviteRequest) -> AnyPublisher<EmptyResponse, Error>
    func cancelAllSharedTeacherInvites() -> AnyPublisher<EmptyResponse, Error>
    func getStudents() -> AnyPublisher<Profile_GetStudentsResponse, Error>
    func removeStudent(request: Profile_RemoveStudentRequest) -> AnyPublisher<EmptyResponse, Error>
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error>
    func getOwnProfileInfo() -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error>
    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error>
    func searchUsers(request: Profile_SearchUsersRequest) -> AnyPublisher<Profile_SearchUsersResponse, Error>
    func generateSharedTeacherInvite(request: Profile_GenerateSharedTeacherInviteRequest) -> AnyPublisher<Profile_GenerateSharedTeacherInviteResponse, Error>
}

final class InviteServiceImpl: InviteService {
    func getTeacher() -> AnyPublisher<Profile_GetTeacherResponse, Error> {
        client.getTeacher(.init()).response.publisher.eraseToAnyPublisher()
    }
    
    func removeTeacher(request: Profile_RemoveTeacherRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.removeTeacher(request).response.publisher.eraseToAnyPublisher()
    }
    
    func sendInviteToTeacher(request: Profile_SendInviteToTeacherRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.sendInviteToTeacher(request).response.publisher.eraseToAnyPublisher()
    }
    
    func sendInviteToStudent(request: Profile_SendInviteToStudentRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.sendInviteToStudent(request).response.publisher.eraseToAnyPublisher()
    }
    
    func acceptInvite(request: Profile_AcceptInviteRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.acceptInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func rejectInvite(request: Profile_RejectInviteRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.rejectInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func generateSharedTeacherInvite(request: Profile_GenerateSharedTeacherInviteRequest) -> AnyPublisher<Profile_GenerateSharedTeacherInviteResponse, Error> {
        client.generateSharedTeacherInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func getSharedInviteInfo(request: Profile_GetSharedInviteInfoRequest) -> AnyPublisher<Profile_GetSharedInviteInfoResponse, Error> {
        client.getSharedInviteInfo(request).response.publisher.eraseToAnyPublisher()
    }
    
    func acceptSharedTeacherInvite(request: Profile_AcceptSharedTeacherInviteRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.acceptSharedTeacherInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func cancelAllSharedTeacherInvites() -> AnyPublisher<EmptyResponse, Error> {
        client.cancelAllSharedTeacherInvites(.init()).response.publisher.eraseToAnyPublisher()
    }
    
    func getStudents() -> AnyPublisher<Profile_GetStudentsResponse, Error> {
        client.getStudents(.init()).response.publisher.eraseToAnyPublisher()
    }
    
    func removeStudent(request: Profile_RemoveStudentRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.removeStudent(request).response.publisher.eraseToAnyPublisher()
    }
    
    func getProfileInfo(request: Profile_GetProfileInfoRequest) -> AnyPublisher<Profile_GetProfileInfoResponse, Error> {
        client.getProfileInfo(request).response.publisher.eraseToAnyPublisher()
    }
    
    func getOwnProfileInfo() -> AnyPublisher<Profile_GetOwnProfileInfoResponse, Error> {
        client.getOwnProfileInfo(.init()).response.publisher.eraseToAnyPublisher()
    }
    
    func updateProfile(request: Profile_UpdateProfileRequest) -> AnyPublisher<Profile_UpdateProfileResponse, Error> {
        client.updateProfile(request).response.publisher.eraseToAnyPublisher()
    }
    
    func searchUsers(request: Profile_SearchUsersRequest) -> AnyPublisher<Profile_SearchUsersResponse, Error> {
        client.searchUsers(request).response.publisher.eraseToAnyPublisher()
    }
    
    
    private let client: Profile_ProfileClientProtocol
    
    init(client: Profile_ProfileClientProtocol) {
        self.client = client
    }
    
    
}
