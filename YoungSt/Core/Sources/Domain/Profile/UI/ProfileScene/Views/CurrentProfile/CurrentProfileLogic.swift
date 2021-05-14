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
    }
    
    switch action {
    case .viewAppeared:
        if state.nickname == nil, let nickname = env.userProvider.currentUser?.nickname {
            state.nickname = "@\(nickname)"
        }
        return .init(value: .profileUpdateRequested)
        
    case .profileUpdateRequested:
        let request = Profile_GetOwnProfileInfoRequest()
        return env.profileService.getOwnProfileInfo(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(CurrentProfileAction.profileUpdated)
            .cancellable(id: Cancellable.updateProfile, bag: env.bag)
        
    case let .profileUpdated(response):
        switch response {
        case let .success(result):
            if result.shouldFillName {
                state.infoState = .infoRequired
            } else {
                state.infoState = .infoProvided(.init(firstName: result.profile.firstName,
                                                      lastName: result.profile.lastName))
            }
        case let .failure(error):
            print(error)
            break
        }
    case .editInfoOpened:
        break
    }
    
    return .none
}

