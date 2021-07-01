//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import ComposableArchitecture
import Resources
import Utilities
import NetworkService

let outcomingStudentInviteReducer = Reducer<OutcomingStudentInviteState, OutcomingStudentInviteAction, OutcomingStudentInviteEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case rejectInvite(UUID)
    }
    
    switch action {
    case .rejectInvite:
        state.isLoading = true
        let request = Profile_RejectInviteRequest.with {
            $0.inviteID = state.id.uuidString
        }
        return env.inviteService.rejectInvite(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(OutcomingStudentInviteAction.inviteRejected)
            .cancellable(id: Cancellable.rejectInvite(state.id), bag: env.bag)
        
    case .inviteRejected:
        state.isLoading = false
    }
    return .none
}
