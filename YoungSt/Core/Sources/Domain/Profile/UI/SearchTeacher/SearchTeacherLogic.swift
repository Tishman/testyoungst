//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.06.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import NetworkService
import Combine

let searchTeacherReducer = Reducer<SearchTeacherState, SearchTeacherAction, SearchTeacherEnvironment> { state, action, env in
    
    enum Cancellable {
        case search
        case teacherInviteInitiated
    }
    
    switch action {
    case let .searchTextChanged(newText):
        state.searchText = newText
        guard !newText.isEmpty else {
            return .merge(
                .init(value: SearchTeacherAction.searchLoaded(.success(.init(text: newText, result: [])))),
                .cancel(id: Cancellable.search, bag: env.bag)
            )
        }
        
        state.isSearchLoading = true
        let request = Profile_SearchUsersRequest.with {
            $0.searchString = newText
        }
        return Just(())
            .delay(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { env.profileService.searchUsers(request: request) }
            .map(\.profiles)
            .tryMap { try .init(text: newText, result: $0.map(ProfileInfo.init(proto:))) }
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(SearchTeacherAction.searchLoaded)
            .cancellable(id: Cancellable.search, cancelInFlight: true, bag: env.bag)
        
    case let .searchLoaded(result):
        state.isSearchLoading = false
        switch result {
        case let .success(response):
            guard response.text == state.searchText else { break }
            state.profileList = .init(response.result)
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case let .profile(id, action: .selected):
        state.isInviteSendingLoading = true
        let request = Profile_SendInviteToTeacherRequest.with {
            $0.teacherID = id.uuidString
        }
        return env.inviteService.sendInviteToTeacher(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(SearchTeacherAction.inviteSended)
            .cancellable(id: Cancellable.teacherInviteInitiated, bag: env.bag)
        
    case let .inviteSended(result):
        state.isInviteSendingLoading = false
        switch result {
        case .success:
            state.isClosed = true
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case .alertClosed:
        state.alert = nil
    }
    
    return .none
}
.debugActions()
