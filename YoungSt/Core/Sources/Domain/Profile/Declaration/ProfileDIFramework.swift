//
//  File.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import DITranquillity

public final class ProfileDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.append(part: ProfileModuleDeclaration.self)
        container.append(part: StudentInviteModuleDeclaration.self)
        
        container.register(ProfileServiceImpl.init)
            .as(check: ProfileService.self) {$0}
        
        container.register(InviteServiceImpl.init)
            .as(check: InviteService.self) {$0}
    }
    
}
