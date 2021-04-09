//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import DITranquillity
import Models

public final class NetworkDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.register(AppCallOptionConfigurator.init)
            .as(check: CallOptionConfigurator.self) {$0}
        
        container.register { () -> ServerConfiguration in
            #if DEBUG
            return .stage
            #else
            return .production
            #endif
        }
        
        container.register(GrpcConnector.init)
            .as(check: NetworkConnector.self) {$0}
            .lifetime(.perContainer(.strong))
        
        container.register(AuthorizationInjectionInterceptorFactory.init)
            .as(check: Authorization_AuthorizationClientInterceptorFactoryProtocol.self) {$0}
        
        container.register { AuthorizationClientFactory(connectionProvider: $0,
                                                        callOptionsProvider: $1,
                                                        interceptors: $2).create() }
            .as(check: Authorization_AuthorizationClientProtocol.self) {$0}
//            .as(check: NetworkClientFactory.self)
        
//        container.register(Authorization_AuthorizationClient.init)
//            .as(check: Authorization_AuthorizationClientProtocol.self) {$0}
    }
    
}
