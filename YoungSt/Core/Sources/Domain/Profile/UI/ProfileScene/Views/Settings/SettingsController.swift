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
    
    var routePublisher: AnyPublisher<SettingsState.Routing?, Never> {
        viewStore.publisher.routing.eraseToAnyPublisher()
    }
    
    init(env: SettingsEnvironment) {
        let store = Store<SettingsState, SettingsAction>(initialState: .init(), reducer: settingsReducer, environment: env)
        
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
            sendEmail(mail: mail)
        }
    }
    
    func resetRouting() {
        viewStore.send(.route(.handled))
    }
    
    func sendEmail(mail: SettingsState.Mail) {
        // Modify following variables with your text / recipient
        
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([mail.recipient])
            mailController.setSubject(mail.subject)
            mailController.setMessageBody(mail.body, isHTML: false)
            
            present(mailController, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: mail.recipient, subject: mail.subject, body: mail.body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
