//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import NetworkService

private struct StudentInviteLogic {
    static func handleLoadInfoResponse(teacherProfile: Profile_GetSharedInviteInfoResponse, currentTeacher: Profile_GetTeacherResponse) throws -> StudentInviteAction.CollectInfoResponse {
        
        guard case let .teacherInvite(profileInfo) = teacherProfile.response else {
            throw BLError.errInternal
        }
        let teacherInfo = try ProfileInfo(proto: profileInfo)
        let alreadyHasTeacher: Bool
        
        switch currentTeacher.response {
        case .teacher:
            alreadyHasTeacher = true
        default:
            alreadyHasTeacher = false
        }
        
        return .init(teacherProfile: teacherInfo, alreadyHasTeacher: alreadyHasTeacher)
    }
}

let studentInviteReducer = Reducer<StudentInviteState, StudentInviteAction, StudentInviteEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case loadInfo
        case sendInviteToTeacher
    }
    
    switch action {
    case .viewAppeared:
        state.isLoading = true
        
        let getInviteInfoRequest = Profile_GetSharedInviteInfoRequest.with {
            $0.id = Int64(state.invite.id)
            $0.password = state.invite.password
        }
        let getTeacherRequest = Profile_GetTeacherRequest()
        
        return env.inviteService.getSharedInviteInfo(request: getInviteInfoRequest)
            .combineLatest(env.inviteService.getTeacher(request: getTeacherRequest))
            .tryMap(StudentInviteLogic.handleLoadInfoResponse)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(StudentInviteAction.infoLoaded)
            .cancellable(id: Cancellable.loadInfo, bag: env.bag)
        
    case let .infoLoaded(result):
        state.isLoading = false
        switch result {
        case let .success(info):
            state.profileInfo = info.teacherProfile
            state.title = info.teacherProfile.displayName
            state.nickname = "@\(info.teacherProfile.nickname)"
            if info.alreadyHasTeacher {
                state.error = Localizable.youCantBecomeStudent
                state.actionType = .close
            } else {
                state.error = nil
                state.subtitle = Localizable.youCanSendRequestToBecomeStudent
                state.actionType = .requestInvite
            }
        case let .failure(error):
            state.error = error.description
            state.actionType = .close
        }
        
    case let .sendInvite(result):
        state.isLoading = false
        switch result {
        case .success:
            return .init(value: .closeScene)
        case let .failure(error):
            state.error = error.description
        }
    case .closeScene:
        state.isClosed = true
        
    case .performAction:
        switch state.actionType {
        case .close:
            return .init(value: .closeScene)
        case .requestInvite:
            state.isLoading = true
            
            let request = Profile_AcceptSharedTeacherInviteRequest.with {
                $0.id = Int64(state.invite.id)
                $0.password = state.invite.password
            }
            
            return env.inviteService.acceptSharedTeacherInvite(request: request)
                .mapError(EquatableError.init)
                .map(toEmpty)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(StudentInviteAction.sendInvite)
                .cancellable(id: Cancellable.sendInviteToTeacher, bag: env.bag)
        }
    }
    
    return .none
}
