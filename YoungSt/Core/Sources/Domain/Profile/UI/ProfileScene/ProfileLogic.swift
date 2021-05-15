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
    
    teacherInfoReducer
        .pullback(state: \.teacherInfoState, action: /ProfileAction.teacherInfo, environment: \.teacherInfoEnv),
    
    Reducer { state, action, env in
        
        let currentProfileTypeKey = "currentProfileTypeKey"
        
        switch action {
        case .viewAppeared:
            state.profileType = env.storage[currentProfileTypeKey] ?? .student
            
        case let .profileTypeChanged(newProfileType):
            state.profileType = newProfileType
            state.selectedTab = .settings
            env.storage[currentProfileTypeKey] = newProfileType
            
        case let .changeSelectedTab(tabIndex):
            let newTab = ProfileState.Tab(rawValue: tabIndex) ?? .settings
            return .init(value: .selectedTabShanged(newTab))
                .receive(on: DispatchQueue.main.animation(.easeOut(duration: 0.3)))
                .eraseToEffect()
            
        case let .selectedTabShanged(newTab):
            state.selectedTab = newTab
            
        case let .fillProfileInfo(.profileEdited(.success(result))),
             let .editProfile(.profileEdited(.success(result))):
            state.currentProfileState.infoState = .infoProvided(.init(firstName: result.profile.firstName,
                                                                      lastName: result.profile.lastName))
            
        case .fillProfileInfo(.closeSceneTriggered), .fillInfoClosed:
            state.fillInfoState = nil
            
        case .editProfile(.closeSceneTriggered), .editProfileClosed:
            state.editProfileState = nil
            
        case .currentProfile(.editInfoOpened):
            state.fillInfoState = .init(shouldFetchProfile: false)
            
        case .editProfileOpened:
            state.editProfileState = .init(shouldFetchProfile: true)
            
        case .currentProfile, .fillProfileInfo, .editProfile, .teacherInfo:
            break
        }
        return .none
    }
)
