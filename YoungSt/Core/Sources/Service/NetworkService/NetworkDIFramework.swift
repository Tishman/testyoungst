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
    }
    
}
