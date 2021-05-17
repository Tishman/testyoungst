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

let shareProfileReducer = Reducer<ShareProfileState, ShareProfileAction, ShareProfileEnvironment> { state, action, env in
    
    func getShareLink() -> URL {
        env.deeplinkService.transform(deeplink: .studentInvite(teacherID: state.userID))
    }
    
    switch action {
    case .viewAppeared:
        state.url = getShareLink().absoluteString
    case .copy:
        UIPasteboard.general.string = getShareLink().absoluteString
    case let .shareOpened(isOpened):
        state.shareURL = isOpened ? getShareLink() : nil
    }
    return .none
}
