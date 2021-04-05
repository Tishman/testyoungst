//
//  TranslateClientFactory.swift
//  YoungSt
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import GRPC
import NIO

public struct TranslateClientFactory: NetworkClientFactory {
    public init(connectionProvider: NetworkConnector,
                callOptionsProvider: CallOptionConfigurator,
                interceptors: Translator_TranslatorClientInterceptorFactoryProtocol?) {
        self.connectionProvider = connectionProvider
        self.callOptionsProvider = callOptionsProvider
        self.interceptors = interceptors
    }
    
    public let connectionProvider: NetworkConnector
    public let callOptionsProvider: CallOptionConfigurator
    public let interceptors: Translator_TranslatorClientInterceptorFactoryProtocol?
    
    public func create() -> Translator_TranslatorClient {
        Translator_TranslatorClient(channel: connectionProvider.getConnection(),
                                    defaultCallOptions: callOptionsProvider.createDefaultCallOptions(),
                                    interceptors: interceptors)
    }
}


public struct TranslatorInjectionInterceptorFactory: Translator_TranslatorClientInterceptorFactoryProtocol {
    public init() {}
    
    public func makeTranslateInterceptors() -> [ClientInterceptor<Translator_TranslationRequest, Translator_TranslationResponse>] {
        [TranslationAPIKeyInjectorInterceptor()]
    }
}

final class TranslationAPIKeyInjectorInterceptor: ClientInterceptor<Translator_TranslationRequest, Translator_TranslationResponse> {

    override func send(_ part: GRPCClientRequestPart<Translator_TranslationRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Translator_TranslationRequest, Translator_TranslationResponse>) {
        switch part {
        case var .metadata(metadata):
            // TODO: Change key for production
            metadata.add(name: "x-api-key", value: "00f098dc-6c8c-4be1-9554-bd61eacd0479_f3c86087-5e28-45ae-98e8-e66badb0bbca")
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}
