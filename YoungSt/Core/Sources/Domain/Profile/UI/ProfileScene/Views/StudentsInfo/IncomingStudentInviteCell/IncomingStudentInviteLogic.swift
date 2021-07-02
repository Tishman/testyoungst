//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import NetworkService

let incomingStudentInviteReducer = Reducer<IncomingStudentInviteState, IncomingStudentInviteAction, IncomingStudentInviteEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case acceptInvite(UUID)
        case rejectInvite(UUID)
    }
    
    switch action {
    case .acceptInvite:
        state.loading = .accept
        let request = Profile_AcceptInviteRequest.with {
            $0.inviteID = state.id.uuidString
        }
        return env.inviteService.acceptInvite(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(IncomingStudentInviteAction.inviteAccepted)
            .cancellable(id: Cancellable.acceptInvite(state.id), bag: env.bag)
        
    case .rejectInvite:
        state.loading = .reject
        let request = Profile_RejectInviteRequest.with {
            $0.inviteID = state.id.uuidString
        }
        return env.inviteService.rejectInvite(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(IncomingStudentInviteAction.inviteRejected)
            .cancellable(id: Cancellable.rejectInvite(state.id), bag: env.bag)
        
    case .inviteAccepted, .inviteRejected:
        state.loading = nil
    }
    return .none
}
