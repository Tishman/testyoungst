//
//  TranslateClientFactory.swift
//  YoungSt
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import NetworkService
import GRPC
import NIO

struct TranslateClientFactory: NetworkClientFactory {
    let connectionProvider: NetworkConnector
    let callOptionsProvider: CallOptionConfigurator
    let interceptors: Translator_TranslatorClientInterceptorFactoryProtocol?
    
    func create() -> Translator_TranslatorClient {
        Translator_TranslatorClient(channel: connectionProvider.getConnection(),
                                    defaultCallOptions: callOptionsProvider.createDefaultCallOptions(),
                                    interceptors: interceptors)
    }
}


struct TranslatorInjectionInterceptorFactory: Translator_TranslatorClientInterceptorFactoryProtocol {
    func makeTranslateInterceptors() -> [ClientInterceptor<Translator_TranslationRequest, Translator_TranslationResponse>] {
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
