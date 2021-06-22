//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import ComposableArchitecture
import Utilities
import NetworkService
import Combine

let searchStudentReducer = Reducer<SearchStudentState, SearchStudentAction, SearchStudentEnvironment> { state, action, env in
    
    enum Cancellable {
        case search
        case studentInviteInitiated
    }
    
    switch action {
    case let .searchTextChanged(newText):
        state.searchText = newText
        guard !newText.isEmpty else {
            return .merge(
                .init(value: SearchStudentAction.searchLoaded(.success(.init(text: newText, result: [])))),
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
            .map(SearchStudentAction.searchLoaded)
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
        let request = Profile_SendInviteToStudentRequest.with {
            $0.studentID = id.uuidString
        }
        return env.inviteService.sendInviteToStudent(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(SearchStudentAction.inviteSended)
            .cancellable(id: Cancellable.studentInviteInitiated, bag: env.bag)
        
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
        
    case .routingHandled:
        state.routing = nil
        
    case let .changeDetail(routing):
        state.routing = routing
    }
    
    return .none
}
