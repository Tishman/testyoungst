//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities

let profileReducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment>.combine(
    currentProfileReducer
        .pullback(state: \.currentProfileState, action: /ProfileAction.currentProfile, environment: \.currentProfileEnv),
    
    teacherInfoReducer
        .pullback(state: \.teacherInfoState, action: /ProfileAction.teacherInfo, environment: \.teacherInfoEnv),
    
    studentsInfoReducer
        .pullback(state: \.studentsInfoState, action: /ProfileAction.studentsInfo, environment: \.studentsInfoEnv),
    
    Reducer { state, action, env in
        
        let currentProfileTypeKey = "currentProfileTypeKey"
        
        switch action {
        case .viewAppeared:
            state.profileType = env.storage[currentProfileTypeKey] ?? .student
            
        case let .profileTypeChanged(newProfileType):
            state.profileType = newProfileType
            env.storage[currentProfileTypeKey] = newProfileType
            
        case .changeDetail(.editProfile):
            state.route = .editProfile
            
        case .changeDetail(.fillInfo):
            state.route = .fillInfo
            
        case let .changeDetail(.openStudent(id)):
            state.route = .openedStudent(userID: id)
            
        case .changeDetail(.closed):
            state.route = nil
            
        case let .studentsInfo(.student(id, .open)):
            return .init(value: .changeDetail(.openStudent(id)))
            
        case .currentProfile(.editInfoOpened):
            return .init(value: .changeDetail(.fillInfo))
            
        case .teacherInfo(.invites(.searchTeacherOpened)):
            state.route = .searchTeacher
            
        case .studentsInfo(.searchStudentsOpened):
            state.route = .searchStudents
            
        case .currentProfile, .teacherInfo, .studentsInfo:
            break
        }
        return .none
    }
)
