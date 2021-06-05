//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import GRPC

struct ProfileInjectionInterceptorFactory: Profile_ProfileClientInterceptorFactoryProtocol {
    func makeGetSharedInviteInfoInterceptors() -> [ClientInterceptor<Profile_GetSharedInviteInfoRequest, Profile_GetSharedInviteInfoResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGenerateSharedTeacherInviteInterceptors() -> [ClientInterceptor<Profile_GenerateSharedTeacherInviteRequest, Profile_GenerateSharedTeacherInviteResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAcceptSharedTeacherInviteInterceptors() -> [ClientInterceptor<Profile_AcceptSharedTeacherInviteRequest, Profile_AcceptSharedTeacherInviteResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeCancelAllSharedTeacherInvitesInterceptors() -> [ClientInterceptor<Profile_CancelAllSharedTeacherInvitesRequest, Profile_CancelAllSharedTeacherInvitesResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetTeacherInterceptors() -> [ClientInterceptor<Profile_GetTeacherRequest, Profile_GetTeacherResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveTeacherInterceptors() -> [ClientInterceptor<Profile_RemoveTeacherRequest, Profile_RemoveTeacherResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeSendInviteToTeacherInterceptors() -> [ClientInterceptor<Profile_SendInviteToTeacherRequest, Profile_SendInviteToTeacherResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAcceptStudentInviteInterceptors() -> [ClientInterceptor<Profile_AcceptStudentInviteRequest, Profile_AcceptStudentInviteResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRejectStudentInviteInterceptors() -> [ClientInterceptor<Profile_RejectStudentInviteRequest, Profile_RejectStudentInviteResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetStudentsInterceptors() -> [ClientInterceptor<Profile_GetStudentsRequest, Profile_GetStudentsResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveStudentInterceptors() -> [ClientInterceptor<Profile_RemoveStudentRequest, Profile_RemoveStudentResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetProfileInfoInterceptors() -> [ClientInterceptor<Profile_GetProfileInfoRequest, Profile_GetProfileInfoResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetOwnProfileInfoInterceptors() -> [ClientInterceptor<Profile_GetOwnProfileInfoRequest, Profile_GetOwnProfileInfoResponse>] {
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
