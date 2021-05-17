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
    static func handleLoadInfoResponse(teacherProfile: Profile_GetProfileInfoResponse, currentTeacher: Profile_GetTeacherResponse) throws -> StudentInviteAction.CollectInfoResponse {
        
        let teacherInfo = try ProfileInfo(proto: teacherProfile.profile)
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
        
        let getProfileRequest = Profile_GetProfileInfoRequest.with {
            $0.id = state.teacherID.uuidString
        }
        let getTeacherRequest = Profile_GetTeacherRequest()
        
        return env.profileService.getProfileInfo(request: getProfileRequest)
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
            state.title = info.teacherProfile.displayName
            state.nickname = "@\(info.teacherProfile.nickname)"
            state.avatarSource = .init(profileInfo: info.teacherProfile)
            if info.alreadyHasTeacher {
                state.error = Localizable.youCantBecomeStudent
                state.actionType = .close
            } else {
                state.error = nil
                state.subtitle = Localizable.youCantBecomeStudent
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
        state.closeHandler.value()
        
    case .performAction:
        switch state.actionType {
        case .close:
            return .init(value: .closeScene)
        case .requestInvite:
            state.isLoading = true
            let request = Profile_SendInviteToTeacherRequest.with {
                $0.teacherID = state.teacherID.uuidString
            }
            
            return env.inviteService.sendInviteToTeacher(request: request)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(StudentInviteAction.sendInvite)
                .cancellable(id: Cancellable.sendInviteToTeacher, bag: env.bag)
        }
    }
    
    return .none
}
