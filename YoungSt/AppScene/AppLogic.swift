//
//  AppLogic.swift
//  YoungSt
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import ComposableArchitecture
import Protocols

let appReducer = Reducer<AppState, AppAction, AppEnviroment>.combine (
    tabReducer.optional().pullback(state: \.authorizedState, action: /AppAction.tab, environment: { _ in ()}),
    Reducer { state, action, env in
        switch action {
        case .appLaunched:
            let credentialsObserver = env.credentialsService.credentialsUpdated
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
                .map(AppLogic.mapCredentialsToAction)
            let currentCredentials = AppLogic.mapCurrentUserIdToAction(userID: env.userProvider.currentUserID)
            
            return .merge(
                credentialsObserver,
                Effect(value: currentCredentials)
            )
            
        case .unauthorized:
            state.authorizedState = nil
        case let .authorized(userID):
            state.authorizedState = .init(userID: userID)
            
        case .tab:
            break
        }
        
        return .none
    }
)

private struct AppLogic {
    
    static func mapCredentialsToAction(newCredentials: Credentials?) -> AppAction {
        return mapCurrentUserIdToAction(userID: newCredentials?.userID)
    }
    
    static func mapCurrentUserIdToAction(userID: UUID?) -> AppAction {
        if let userID = userID {
            return .authorized(userID: userID)
        } else {
            return .unauthorized
        }
    }
    
}
