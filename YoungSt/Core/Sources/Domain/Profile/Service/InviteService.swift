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
    func getTeacher(request: Profile_GetTeacherRequest) -> AnyPublisher<Profile_GetTeacherResponse, Error>
    func removeTeacher(request: Profile_RemoveTeacherRequest) -> AnyPublisher<Profile_RemoveTeacherResponse, Error>
    func sendInviteToTeacher(request: Profile_SendInviteToTeacherRequest) -> AnyPublisher<Profile_SendInviteToTeacherResponse, Error>
    func acceptStudentInvite(request: Profile_AcceptStudentInviteRequest) -> AnyPublisher<Profile_AcceptStudentInviteResponse, Error>
    func rejectStudentInvite(request: Profile_RejectStudentInviteRequest) -> AnyPublisher<Profile_RejectStudentInviteResponse, Error>
    func getStudents(request: Profile_GetStudentsRequest) -> AnyPublisher<Profile_GetStudentsResponse, Error>
    func removeStudent(request: Profile_RemoveStudentRequest) -> AnyPublisher<Profile_RemoveStudentResponse, Error>
}

final class InviteServiceImpl: InviteService {
    
    private let client: Profile_ProfileClientProtocol
    
    init(client: Profile_ProfileClientProtocol) {
        self.client = client
    }
    
    func getTeacher(request: Profile_GetTeacherRequest) -> AnyPublisher<Profile_GetTeacherResponse, Error> {
        client.getTeacher(request).response.publisher.eraseToAnyPublisher()
    }
    
    func removeTeacher(request: Profile_RemoveTeacherRequest) -> AnyPublisher<Profile_RemoveTeacherResponse, Error> {
        client.removeTeacher(request).response.publisher.eraseToAnyPublisher()
    }
    
    func sendInviteToTeacher(request: Profile_SendInviteToTeacherRequest) -> AnyPublisher<Profile_SendInviteToTeacherResponse, Error> {
        client.sendInviteToTeacher(request).response.publisher.eraseToAnyPublisher()
    }
    
    func acceptStudentInvite(request: Profile_AcceptStudentInviteRequest) -> AnyPublisher<Profile_AcceptStudentInviteResponse, Error> {
        client.acceptStudentInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func rejectStudentInvite(request: Profile_RejectStudentInviteRequest) -> AnyPublisher<Profile_RejectStudentInviteResponse, Error> {
        client.rejectStudentInvite(request).response.publisher.eraseToAnyPublisher()
    }
    
    func getStudents(request: Profile_GetStudentsRequest) -> AnyPublisher<Profile_GetStudentsResponse, Error> {
        client.getStudents(request).response.publisher.eraseToAnyPublisher()
    }
    
    func removeStudent(request: Profile_RemoveStudentRequest) -> AnyPublisher<Profile_RemoveStudentResponse, Error> {
        client.removeStudent(request).response.publisher.eraseToAnyPublisher()
    }
    
    
}
