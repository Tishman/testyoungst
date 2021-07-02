//
//  File.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import Foundation
import DITranquillity
import UIKit
import Coordinator
import Protocols

public final class ProfileDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.register(ShareProfileEnvironment.init)
        container.register(ShareProfileController.init(env:))
        
        container.register(SearchStudentEnvironment.init)
        container.register(SearchStudentController.init(env:routingPoints:))
        container.register(SearchStudentRoutingPoints.init)
        
        container.register(SearchTeacherEnvironment.init)
        container.register(SearchTeacherController.init(env:))
        
        container.register(EditProfileEnvironment.init)
        container.register { EditProfileController(env: $0) }
        container.register { FinishProfileUpdatingController(env: $0) }
        
        container.register(StudentInviteEnvironment.init)
        container.register {
            StudentInviteController(input: arg($0), env: $1)
        }
        
        container.register(SettingsEnvironment.init)
        container.register { env in { (input: SettingsInput) in
            SettingsController(env: env).erased
        }}
        
        // Fod module link
        container.register { env in { input in
            UINavigationController(rootViewController: StudentInviteController(input: input, env: env)).erased
        }}
        
        container.register(ProfileEnvironment.init)
        container.register(ProfileControllerRoutingPoints.init)
        container.register {
            ProfileController(input: arg($0), env: $1, routingPoints: $2)
        }
        .injection(cycle: true, \.coordinator)
        
        // Fod module link
        container.register { (env: ProfileEnvironment, routingPoints: ProfileControllerRoutingPoints) in { (input: ProfileInput, coordinator: Coordinator) -> UIViewController in
            let vc = ProfileController(input: input, env: env, routingPoints: routingPoints)
            vc.coordinator = coordinator
            return vc
        }}
        
        container.register(ProfileServiceImpl.init)
            .as(check: ProfileService.self) {$0}
        
        container.register(InviteServiceImpl.init)
            .as(check: InviteService.self) {$0}
        
        container.register(ProfileEventPublisherImpl.init)
            .as(check: ProfileEventPublisher.self) {$0}
            .lifetime(.perContainer(.weak))
    }
    
}
