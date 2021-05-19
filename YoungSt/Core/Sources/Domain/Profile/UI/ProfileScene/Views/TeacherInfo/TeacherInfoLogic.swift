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

let teacherInfoReducer = Reducer<TeacherInfoState, TeacherInfoAction, TeacherInfoEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case loadTeacher
        case removeTeacher
    }
    
    switch action {
    case .viewAppeared:
        return .init(value: .reload)
        
    case .reload:
        let request = Profile_GetTeacherRequest()
        return env.inviteService.getTeacher(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(TeacherInfoAction.teacherLoaded)
            .cancellable(id: Cancellable.loadTeacher, bag: env.bag)
        
    case let .teacherLoaded(result):
        switch result {
        case let .success(teacher):
            switch teacher.response {
            case let .teacher(teacher):
                guard let teacherInfo = try? CurrentTeacher(profile: .init(proto: teacher.profile), inviteAccepted: teacher.inviteAccepted) else {
                    state = .error
                    break
                }
                state = .exists(teacherInfo)
            default:
                state = .empty
            }
        case .failure:
            state = .error
        }
        
    case let .teacherRemoved(result):
        switch result {
        case .success:
            state = .empty
        case .failure:
            state = .error
        }
        
    case .removeTeacher:
        guard case let .exists(teacher) = state else {
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
    }
    
    return .none
}
