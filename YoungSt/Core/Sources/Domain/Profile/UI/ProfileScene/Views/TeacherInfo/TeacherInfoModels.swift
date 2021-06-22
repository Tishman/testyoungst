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

struct TeacherInfoState: Equatable, Previwable {
    var alert: AlertState<TeacherInfoAction>?
    var isLoading = false
    var uiState = TeacherInfoUIState.loading
    
    static let preview: TeacherInfoState = .init(uiState: .preview)
}

enum TeacherInfoUIState: Equatable, Previwable {
    case loading
    case error
    case invites(InvitesTeacherState)
    case exists(TeacherInfoExistsState)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
    
    var invitesState: InvitesTeacherState? {
        get {
            switch self {
            case let .invites(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard case .invites = self,
                  let newValue = newValue
            else { return }
            self = .invites(newValue)
        }
    }
    
    var existedState: TeacherInfoExistsState? {
        get {
            switch self {
            case let .exists(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard case .exists = self,
                  let newValue = newValue
            else { return }
            self = .exists(newValue)
        }
    }
    
    static var preview: Self = .exists(.init(profile: .preview))
}

enum TeacherInfoAction: Equatable {
    case viewAppeared
    case reload
    
    case teacherLoaded(Result<Profile_GetTeacherResponse, EquatableError>)
    case teacherRemoved(Result<EmptyResponse, EquatableError>)
    
    case existed(ExistedTeacherAction)
    case invites(InvitesTeacherAction)
    case alertClosed
    
    case inviteRejected(Result<UUID, EquatableError>)
    case inviteAccepted(Result<EmptyResponse, EquatableError>)
}

struct TeacherInfoEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
}
