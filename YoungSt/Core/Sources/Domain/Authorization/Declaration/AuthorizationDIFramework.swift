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
		
		container.register(LoginEnviroment.init)
		container.register(LoginRoutingPoints.init)
		container.register {
			LoginController(env: $0, routingPoints: $1)
		}
		
		container.register(RegistrationEnviroment.init)
		container.register(RegistrationRoutingPoints.init)
		container.register {
			RegistrationController(env: $0, routingPoints: $1)
		}
		
		container.register(ForgotPasswordEnviroment.init)
        container.register(ForgotPasswordRoutingPoints.init)
        container.register {
            ForgotPasswordController(input: arg($0), env: $1, routingPoints: $2)
        }
        
        container.register(VerificationEnviroment.init)
        container.register(VerificationRoutingPoints.init)
        container.register {
            VerificationController(email: arg($0), env: $1, routingPoints: $2)
        }
        
        container.register(ChangePasswordEnviroment.init)
        container.register {
            ChangePasswordController(input: arg($0), env: $1)
        }
		
		container.register(ConfrimEmailEnviroment.init)
		container.register {
            ConfrimEmailController(input: arg($0), env: $1)
		}
		
		container.register(WelcomeEnviroment.init)
		container.register(WelcomeRoutingPoints.init)
        
		// For module's link
        container.register { env, routingPoints in { (input: WelcomeInput) in
			UINavigationController(rootViewController: WelcomeViewController(input: input, env: env, routingPoints: routingPoints)).erased
        }}
        
        container.register(CredentialsServiceImpl.init)
            .as(check: CredentialsService.self) {$0}
            .as(check: SessionProvider.self) {$0}
            .as(check: UserProvider.self) {$0}
            .lifetime(.perContainer(.strong))
    }
}
