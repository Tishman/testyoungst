//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import GRPC

struct ProfileInjectionInterceptorFactory: Profile_ProfileClientInterceptorFactoryProtocol {
    func makeGetTeacherInterceptors() -> [ClientInterceptor<EmptyResponse, Profile_GetTeacherResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveTeacherInterceptors() -> [ClientInterceptor<Profile_RemoveTeacherRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeSendInviteToTeacherInterceptors() -> [ClientInterceptor<Profile_SendInviteToTeacherRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeSendInviteToStudentInterceptors() -> [ClientInterceptor<Profile_SendInviteToStudentRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAcceptInviteInterceptors() -> [ClientInterceptor<Profile_AcceptInviteRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRejectInviteInterceptors() -> [ClientInterceptor<Profile_RejectInviteRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAcceptSharedTeacherInviteInterceptors() -> [ClientInterceptor<Profile_AcceptSharedTeacherInviteRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeCancelAllSharedTeacherInvitesInterceptors() -> [ClientInterceptor<EmptyResponse, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetStudentsInterceptors() -> [ClientInterceptor<EmptyResponse, Profile_GetStudentsResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveStudentInterceptors() -> [ClientInterceptor<Profile_RemoveStudentRequest, EmptyResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetOwnProfileInfoInterceptors() -> [ClientInterceptor<EmptyResponse, Profile_GetOwnProfileInfoResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeSearchUsersInterceptors() -> [ClientInterceptor<Profile_SearchUsersRequest, Profile_SearchUsersResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetSharedInviteInfoInterceptors() -> [ClientInterceptor<Profile_GetSharedInviteInfoRequest, Profile_GetSharedInviteInfoResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGenerateSharedTeacherInviteInterceptors() -> [ClientInterceptor<Profile_GenerateSharedTeacherInviteRequest, Profile_GenerateSharedTeacherInviteResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetProfileInfoInterceptors() -> [ClientInterceptor<Profile_GetProfileInfoRequest, Profile_GetProfileInfoResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeUpdateProfileInterceptors() -> [ClientInterceptor<Profile_UpdateProfileRequest, Profile_UpdateProfileResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    private let dependencies: CommonInterceptorDependencies
    
    init(dependencies: CommonInterceptorDependencies) {
        self.dependencies = dependencies
    }
    
}
