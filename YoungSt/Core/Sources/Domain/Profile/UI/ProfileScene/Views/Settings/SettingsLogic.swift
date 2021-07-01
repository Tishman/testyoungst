//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import Foundation
import ComposableArchitecture
import Resources

let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, env in
    switch action {
    case .alertClosed:
        state.alert = nil
        
    case .logoutPressed:
        state.alert = .init(title: TextState(Localizable.logoutAlertConfirmationTitle),
                            message: nil,
                            primaryButton: .destructive(TextState(Localizable.logoutAlertConfirmationAction), send: .logoutConfirmed),
                            secondaryButton: .cancel())
        
    case .logoutConfirmed:
        env.credentialsService.clearCredentials()
    }
    
    return .none
}
