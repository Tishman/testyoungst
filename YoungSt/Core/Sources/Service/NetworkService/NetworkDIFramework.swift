//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import DITranquillity
import GRPC

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
        
        container.register(CommonInterceptorDependencies.init)
        
        container.register(GrpcConnector.init)
            .as(check: NetworkConnector.self) {$0}
            .lifetime(.perContainer(.strong))
        
        container.register(AuthorizationInjectionInterceptorFactory.init)
            .as(check: Authorization_AuthorizationClientInterceptorFactoryProtocol.self) {$0}
        
        container.register(DictionariesInjectionInterceptorFactory.init)
            .as(check: Dictionary_UserDictionaryClientInterceptorFactoryProtocol.self) {$0}
        
        container.register(TranslatorInjectionInterceptorFactory.init)
            .as(check: Translator_TranslatorClientInterceptorFactoryProtocol.self) {$0}
        
        container.register {
            ($0 as NetworkConnector).getConnection()
        }
        container.register {
            Authorization_AuthorizationClient(channel: $0 as ClientConnection,
                                              defaultCallOptions: ($1 as CallOptionConfigurator).createDefaultCallOptions(),
                                              interceptors: $2 as Authorization_AuthorizationClientInterceptorFactoryProtocol)
        }
        .as(check: Authorization_AuthorizationClientProtocol.self) {$0}
        
        container.register {
            Translator_TranslatorClient(channel: $0 as ClientConnection,
                                        defaultCallOptions: ($1 as CallOptionConfigurator).createDefaultCallOptions(),
                                        interceptors: $2 as Translator_TranslatorClientInterceptorFactoryProtocol)
        }
        .as(check: Translator_TranslatorClientProtocol.self) {$0}
        
        container.register {
            Dictionary_UserDictionaryClient(channel: $0 as ClientConnection,
                                            defaultCallOptions: ($1 as CallOptionConfigurator).createDefaultCallOptions(),
                                            interceptors: $2 as Dictionary_UserDictionaryClientInterceptorFactoryProtocol)
        }
        .as(check: Dictionary_UserDictionaryClientProtocol.self) {$0}
        
            
//            .as(check: NetworkClientFactory.self)
        
//        container.register(Authorization_AuthorizationClient.init)
//            .as(check: Authorization_AuthorizationClientProtocol.self) {$0}
    }
    
}
