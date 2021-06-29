//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import NetworkService

private struct TeacherInfoLogic {
    static func createState(from response: Profile_GetTeacherResponse) -> TeacherInfoUIState {
        var inviteState = InvitesTeacherState()
        
        switch response.response {
        case let .teacher(teacher):
            guard let teacherInfo = try? TeacherInfoExistsState(profile: .init(proto: teacher.profile)) else {
                return .error
            }
            return .exists(teacherInfo)
            
        case let .outcomingInvite(invite):
            inviteState.outcoming = try? .init(proto: invite)
            
        case .empty, .none:
            break
        }
        inviteState.incoming = .init(response.incomingTeacherRequests.compactMap { try? InvitesTeacherState.Invite(proto: $0) })
        
        return .invites(inviteState)
    }
}

let teacherInfoReducer = Reducer<TeacherInfoState, TeacherInfoAction, TeacherInfoEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case loadTeacher
        case removeTeacher
        case observeTeacher
        case acceptInvite(UUID)
        case rejectInvite(UUID)
    }
    
    switch action {
    case .viewAppeared:
        let observeTeacherEvents = env.profileEventPublisher.publisher
            .filter { $0 == .teacherInfoUpdated }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
            .map { _ in TeacherInfoAction.reload }
            .cancellable(id: Cancellable.observeTeacher, cancelInFlight: true, bag: env.bag)
        
        return .merge(.init(value: .reload), observeTeacherEvents)
        
    case .reload:
        state.isLoading = true
        return env.inviteService.getTeacher()
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main.animation())
            .catchToEffect()
            .map(TeacherInfoAction.teacherLoaded)
            .cancellable(id: Cancellable.loadTeacher, bag: env.bag)
        
    case let .teacherLoaded(result):
        state.isLoading = false
        switch result {
        case let .success(teacher):
            state.uiState = TeacherInfoLogic.createState(from: teacher)
        case .failure:
            state.uiState = .error
        }
        
    case let .teacherRemoved(result):
        switch result {
        case .success:
            state.uiState = .invites(.init())
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case .existed(.removeTeacher):
        guard case let .exists(teacher) = state.uiState else {
            break
        }
        let request = Profile_RemoveTeacherRequest.with {
            $0.teacherID = teacher.profile.id.uuidString
        }
        return env.inviteService.removeTeacher(request: request)
            .map(toEmpty)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(TeacherInfoAction.teacherRemoved)
            .cancellable(id: Cancellable.removeTeacher, bag: env.bag)
        
    case .alertClosed:
        state.alert = nil
        
    case let .invites(.inviteAction(id, .accept)):
        let request = Profile_AcceptInviteRequest.with {
            $0.inviteID = id.uuidString
        }
        state.isLoading = true
        return env.inviteService.acceptInvite(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(TeacherInfoAction.inviteAccepted)
            .cancellable(id: Cancellable.acceptInvite(id), bag: env.bag)
        
    case let .invites(.inviteAction(id, .reject)):
        let request = Profile_RejectInviteRequest.with {
            $0.inviteID = id.uuidString
        }
        state.isLoading = true
        return env.inviteService.rejectInvite(request: request)
            .mapError(EquatableError.init)
            .map { _ in id }
            .receive(on: DispatchQueue.main.animation())
            .catchToEffect()
            .map(TeacherInfoAction.inviteRejected)
            .cancellable(id: Cancellable.rejectInvite(id), bag: env.bag)
            
    case let .inviteAccepted(response):
        switch response {
        case .success:
            return .init(value: .reload)
            
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
            state.isLoading = false
        }
        
    case let .inviteRejected(response):
        state.isLoading = false
        
        switch response {
        case let .success(id):
            guard var invitesState = state.uiState.invitesState else { break }
            if invitesState.incoming[id: id] != nil {
                invitesState.incoming.remove(id: id)
            }
            if invitesState.outcoming?.id == id {
                invitesState.outcoming = nil
            }
            state.uiState = .invites(invitesState)
            
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case .invites(.searchTeacherOpened):
        break
    }
    
    return .none
}
