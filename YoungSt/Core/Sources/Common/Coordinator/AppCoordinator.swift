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
    
    func view(for link: ModuleLink) -> AnyView {
        switch link {
        case let .authorization(input):
            return authorizationProvider(input)
        }
    }
}
