//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import UIKit
import NetworkService

let shareProfileReducer = Reducer<ShareProfileState, ShareProfileAction, ShareProfileEnvironment> { state, action, env in
    
    enum Cancellable: Hashable {
        case shareProfileLink
    }
    
    switch action {
    case .viewAppeared:
        state.isLoading = true
        let request = Profile_GenerateSharedTeacherInviteRequest()
        return env.inviteService.generateSharedTeacherInvite(request: request)
            .mapError(EquatableError.init)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(ShareProfileAction.shareGenerated)
        
    case let .shareGenerated(result):
        state.isLoading = false
        
        switch result {
        case let .success(response):
            state.url = response.url
        case let .failure(error):
            state.alert = .init(title: TextState(error.description))
        }
        
    case .copy:
        UIPasteboard.general.string = state.url
        
    case let .shareOpened(isOpened):
        guard let url = URL(string: state.url) else {
            state.shareURL = nil
            break
        }
        state.shareURL = isOpened ? url : nil
        
    case .alertClosed:
        state.isClosed = true
    }
    return .none
}
