//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI
import SwiftLazy

struct AppCoordinator: Coordinator {
    
    let welcomeProvider: (WelcomeInput) -> UIViewController
    let dictionariesProvider: (DictionariesInput) -> UIViewController
    let profileProvider: (ProfileInput, Coordinator) -> UIViewController
    let addWordProvider: (AddWordInput) -> UIViewController
    let studentInviteProvider: (StudentInviteInput) -> UIViewController
    
    func view(for link: ModuleLink) -> UIViewController {
        switch link {
		case let .authorization(input):
            return welcomeProvider(input)
        case let .dictionaries(input):
            return dictionariesProvider(input)
        case let .profile(input):
            return profileProvider(input, self)
        case let .addWord(input):
            return addWordProvider(input)
        case let .studentInvite(input):
            return studentInviteProvider(input)
        }
    }
}
