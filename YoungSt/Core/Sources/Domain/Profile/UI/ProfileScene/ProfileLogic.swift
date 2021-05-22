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
    
    editProfileReducer
        .optional(bag: \.bag)
        .pullback(state: \.fillInfoState, action: /ProfileAction.fillProfileInfo) {
            $0.editProfileEnv(bag: .autoId(childOf: $0.bag))
        },
    
    editProfileReducer
        .optional(bag: \.bag)
        .pullback(state: \.editProfileState, action: /ProfileAction.editProfile) {
            $0.editProfileEnv(bag: .autoId(childOf: $0.bag))
        },
    
    shareProfileReducer
        .optional(bag: \.bag)
        .pullback(state: \.shareProfileState, action: /ProfileAction.shareProfile, environment: \.shareProfileEnv),
    
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
            
        case let .fillProfileInfo(.profileEdited(.success(result))),
             let .editProfile(.profileEdited(.success(result))):
            state.currentProfileState.infoState = .infoProvided(.init(firstName: result.profile.firstName,
                                                                      lastName: result.profile.lastName))
            
        case .changeDetail(.editProfile):
            state.detailState = .editProfile(state.editProfileState ?? .init(shouldFetchProfile: true))
            
        case .changeDetail(.fillInfo):
            state.detailState = .fillInfo(state.fillInfoState ?? .init(shouldFetchProfile: false))
            
        case .changeDetail(.shareProfile):
            state.detailState = .shareProfile(state.shareProfileState ?? .init(userID: state.userID))
            
        case let .changeDetail(.openStudent(id)):
            state.detailState = .openedStudent(id)
            
        case .changeDetail(.closed): break
            
        case //.changeDetail(.closed),
             .editProfile(.closeSceneTriggered),
             .fillProfileInfo(.closeSceneTriggered):
            state.detailState = nil
            
        case let .studentsInfo(.studentOpened(id)):
            return .init(value: .changeDetail(.openStudent(id)))
            
        case .currentProfile(.editInfoOpened):
            return .init(value: .changeDetail(.fillInfo))
            
        case .logout:
            env.credentialsService.clearCredentials()
            
        case .currentProfile, .fillProfileInfo, .editProfile, .teacherInfo, .studentsInfo, .shareProfile:
            break
        }
        return .none
    }
)
.debugActions()
