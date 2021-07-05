//
//  File.swift
//  
//
//  Created by Nikita Patskov on 05.07.2021.
//

import UIKit
import MessageUI

protocol MailSendingService: AnyObject {
    func send(mail: MailInfo, presenter: UIViewController)
}

struct MailInfo: Equatable {
    let recipient: String
    let subject: String
    let body: String
}

final class MailSendingServiceImpl: NSObject, MailSendingService, MFMailComposeViewControllerDelegate {
    
    func send(mail: MailInfo, presenter: UIViewController) {
        // Modify following variables with your text / recipient
        
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([mail.recipient])
            mailController.setSubject(mail.subject)
            mailController.setMessageBody(mail.body, isHTML: false)
            
            presenter.present(mailController, animated: true)
            
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
