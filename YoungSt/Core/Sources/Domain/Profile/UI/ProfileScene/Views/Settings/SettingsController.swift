//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture
import MessageUI
import Combine
import Coordinator

final class SettingsController: UIHostingController<SettingsScene>, MFMailComposeViewControllerDelegate, RoutableController {
    
    private let store: Store<SettingsState, SettingsAction>
    private let viewStore: ViewStore<SettingsState, SettingsAction>
    private var bag: Set<AnyCancellable> = []
    private let mailSendingService: MailSendingService
    
    var routePublisher: AnyPublisher<SettingsState.Routing?, Never> {
        viewStore.publisher.routing.eraseToAnyPublisher()
    }
    
    init(env: SettingsEnvironment, mailSendingService: MailSendingService) {
        let store = Store<SettingsState, SettingsAction>(initialState: .init(), reducer: settingsReducer, environment: env)
        
        self.mailSendingService = mailSendingService
        self.store = store
        self.viewStore = .init(store)
        
        super.init(rootView: SettingsScene(store: store))
        
        observeRouting().store(in: &bag)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handle(routing: Routing) {
        switch routing {
        case let .mail(mail):
            mailSendingService.send(mail: mail, presenter: self)
        }
    }
    
    func resetRouting() {
        viewStore.send(.route(.handled))
    }
    
    
    
}
