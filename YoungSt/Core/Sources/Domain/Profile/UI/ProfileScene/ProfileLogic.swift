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
        let currentProfileTabKey = "currentProfileTabKey"
        
        switch action {
        case .viewAppeared:
            state.profileType = env.storage[currentProfileTypeKey] ?? .student
            state.selectedTab = env.storage[currentProfileTabKey] ?? .settings
            
        case let .profileTypeChanged(newProfileType):
            state.profileType = newProfileType
            env.storage[currentProfileTypeKey] = newProfileType
            return .init(value: .changeSelectedTab(ProfileState.Tab.settings.rawValue))
            
        case let .changeSelectedTab(tabIndex):
            let newTab = ProfileState.Tab(rawValue: tabIndex) ?? .settings
            return .init(value: .selectedTabShanged(newTab))
                .receive(on: DispatchQueue.main.animation(.easeOut(duration: 0.3)))
                .eraseToEffect()
            
        case let .selectedTabShanged(newTab):
            state.selectedTab = newTab
            env.storage[currentProfileTabKey] = newTab
            
        case .changeDetail(.editProfile):
            state.route = .editProfile
            
        case .changeDetail(.fillInfo):
            state.route = .fillInfo
            
        case .changeDetail(.shareProfile):
            state.route = .shareProfile(userID: state.userID)
            
        case let .changeDetail(.openStudent(id)):
            state.route = .openedStudent(userID: id)
            
        case .changeDetail(.closed):
            state.route = nil
            
        case let .studentsInfo(.studentOpened(id)):
            return .init(value: .changeDetail(.openStudent(id)))
            
        case .currentProfile(.editInfoOpened):
            return .init(value: .changeDetail(.fillInfo))
            
        case .logout:
            env.credentialsService.clearCredentials()
            
        case .currentProfile, .teacherInfo, .studentsInfo, .shareProfile:
            break
        }
        return .none
    }
)
.debugActions()
