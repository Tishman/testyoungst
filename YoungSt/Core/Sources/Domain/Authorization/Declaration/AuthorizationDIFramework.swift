//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import DITranquillity
import Coordinator
import SwiftUI
import Protocols

public final class AuthorizationDIFramework: DIFramework {
    public static func load(container: DIContainer) {
        container.append(part: AuthorizationModuleDelaration.self)
        
        container.register(AuthorizationServiceImpl.init)
            .as(check: AuthorizationService.self) {$0}
        
        container.register(CredentialsServiceImpl.init)
            .as(check: CredentialsService.self) {$0}
            .as(check: SessionProvider.self) {$0}
            .as(check: UserProvider.self) {$0}
    }
}
