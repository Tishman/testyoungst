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
            
        case .refreshTriggered:
            switch state.profileType {
            case .student:
                return .init(value: .teacherInfo(.reload))
            case .teacher:
                return .init(value: .studentsInfo(.updateList))
            }
            
        case let .profileTypeChanged(newProfileType):
            state.profileType = newProfileType
            env.storage[currentProfileTypeKey] = newProfileType
            
        case .route(.editProfile):
            state.route = .editProfile
            
        case .route(.fillInfo):
            state.route = .fillInfo
            
        case let .route(.openStudent(id)):
            state.route = .openedStudent(userID: id)
            
        case .route(.handled):
            state.route = nil
            
        case let .studentsInfo(.student(id, .open)):
            return .init(value: .route(.openStudent(id)))
            
        case .currentProfile(.editInfoOpened):
            return .init(value: .route(.fillInfo))
            
        case .teacherInfo(.invites(.searchTeacherOpened)):
            state.route = .searchTeacher
            
        case .studentsInfo(.searchStudentsOpened):
            state.route = .searchStudents
            
        case .currentProfile, .teacherInfo, .studentsInfo:
            break
        }
        return .none
    }
    .analytics()
)
