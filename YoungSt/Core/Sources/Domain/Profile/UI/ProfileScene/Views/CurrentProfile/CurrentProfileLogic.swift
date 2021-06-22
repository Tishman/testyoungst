//
//  File.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import NetworkService
import Utilities

let currentProfileReducer = Reducer<CurrentProfileState, CurrentProfileAction, CurrentProfileEnvironment> { state, action, env in
    enum Cancellable: Hashable {
        case updateProfile
        case profileInfoObserver
    }
    
    switch action {
    case .viewAppeared:
        if state.nickname == nil, let nickname = env.userProvider.currentUser?.nickname {
            state.nickname = nickname
        }
        if let currentProfile = env.userProvider.currentProfile, !currentProfile.firstName.isEmpty {
            state.infoState = .infoProvided(.init(firstName: currentProfile.firstName,
                                                  lastName: currentProfile.lastName))
        }
        
        return .merge(
            .init(value: .profileUpdateRequested),
            env.credentialsService.profileUpdated
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
                .map(CurrentProfileAction.userInfoUpdated)
                .cancellable(id: Cancellable.profileInfoObserver, cancelInFlight: true, bag: env.bag)
        )
        
    case .profileUpdateRequested:
        return env.profileService.getOwnProfileInfo()
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(CurrentProfileAction.profileUpdated)
            .cancellable(id: Cancellable.updateProfile, bag: env.bag)
        
    case let .profileUpdated(response):
        switch response {
        case let .success(result):
            if result.shouldFillName || result.profile.firstName.isEmpty {
                state.infoState = .infoRequired
            } else {
                state.infoState = .infoProvided(.init(firstName: result.profile.firstName,
                                                      lastName: result.profile.lastName))
            }
        case let .failure(error):
            print(error)
            break
        }
        
    case let .userInfoUpdated(userInfo):
        state.nickname = userInfo.nickname
    
    case .editInfoOpened:
        break
    }
    
    return .none
}

