//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI

struct AppCoordinator: Coordinator {
    
    let authorizationProvider: (AuthorizationInput) -> AnyView
    let dictionariesProvider: (DictionariesInput) -> AnyView
    let profileProvider: (ProfileInput) -> AnyView
    let addWordProvider: (AddWordInput) -> AnyView
    let studentInviteProvider: (StudentInviteInput) -> AnyView
    
    func view(for link: ModuleLink) -> AnyView {
        switch link {
        case let .authorization(input):
            return authorizationProvider(input)
        case let .dictionaries(input):
            return dictionariesProvider(input)
        case let .profile(input):
            return profileProvider(input)
        case let .addWord(input):
            return addWordProvider(input)
        case let .studentInvite(input):
            return studentInviteProvider(input)
        }
    }
}
