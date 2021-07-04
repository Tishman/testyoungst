//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities

let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, env in
    switch action {
    case .alertClosedTriggered:
        state.alert = nil
        
    case .logoutTriggered:
        state.alert = .init(title: TextState(Localizable.logoutAlertConfirmationTitle),
                            message: nil,
                            primaryButton: .destructive(TextState(Localizable.logoutAlertConfirmationAction), send: .logoutConfirmTriggered),
                            secondaryButton: .cancel())
        
    case .logoutConfirmTriggered:
        env.credentialsService.clearCredentials()
        
    case .route(.mail):
        var body = """
        App info: \(SettingsScene.versionInfo)
        """
        env.userProvider.currentUserID.map {
            body.append("User id: \($0.uuidString)\n")
        }
        
        
        let mail = SettingsState.Mail(recipient: "vyoungst@gmail.com",
                                      subject: "Feedback",
                                      body: body)
        state.routing = .mail(mail)
        
    case .route(.handled):
        state.routing = nil
    }
    
    return .none
}
.analytics()
