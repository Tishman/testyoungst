//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import NetworkService
import Resources


private struct EditProfileLogic {
    static func isFirstNameValid(firstName: String) -> Bool {
        !firstName.isEmpty
    }
    
    static func isNicknameValid(nickname: String) -> Bool {
        !nickname.isEmpty
    }
}

let editProfileReducer = Reducer<EditProfileState, EditProfileAction, EditProfileEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case fetchProfile
        case updateProfile
    }
    
    switch action {
    case .viewAppeared:
        if let userInfo = env.userProvider.currentUser {
            state.nickname = userInfo.nickname
        }
        if let profileInfo = env.userProvider.currentProfile {
            state.firstName = profileInfo.firstName
            state.lastName = profileInfo.lastName
        }
        if state.shouldFetchProfile {
            return .init(value: .updateProfileRequested)
        }
        
    case .updateProfileRequested:
        let request = Profile_GetOwnProfileInfoRequest()
        
        return env.profileService.getOwnProfileInfo(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(EditProfileAction.profileFetched)
            .cancellable(id: Cancellable.fetchProfile, bag: env.bag)
        
    case let .firstNameChanged(firstName):
        state.firstNameError = nil
        state.firstName = firstName
        
    case let .lastNameChanged(lastName):
        state.lastName = lastName
        
    case let .nicknameChanged(nickname):
        state.nicknameError = nil
        state.nickname = nickname
        
    case let .profileFetched(result):
        switch result {
        case let .success(response):
            state.firstName = response.profile.firstName
            state.lastName = response.profile.lastName
            state.nickname = response.profile.nickname
        case .failure:
            break
        }
        
    case .editProfileTriggered:
        let firstName = state.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = state.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let nickname = state.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard EditProfileLogic.isFirstNameValid(firstName: firstName) else {
            state.firstNameError = Localizable.invalidFirstName
            break
        }
        
        guard EditProfileLogic.isNicknameValid(nickname: nickname) else {
            state.nicknameError = Localizable.invalidNickname
            break
        }
        
        let request = Profile_UpdateProfileRequest.with {
            $0.firstName = firstName
            $0.lastName = lastName
            $0.nickname = nickname
        }
        state.isLoading = true
        
        return env.profileService.updateProfile(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(EditProfileAction.profileEdited)
            .cancellable(id: Cancellable.updateProfile, bag: env.bag)
        
    case let .profileEdited(result):
        state.isLoading = false
        switch result {
        case let .success(response):
            return .init(value: .closeSceneTriggered)
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case .alertClosed:
        state.alert = nil
        
    case .closeSceneTriggered:
        state.isClosed = true
    }
    return .none
}
