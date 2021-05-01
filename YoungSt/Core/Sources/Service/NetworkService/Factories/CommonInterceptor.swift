//
//  File.swift
//  
//
//  Created by Nikita Patskov on 28.04.2021.
//

import Foundation
import GRPC
import NIO
import Protocols

struct CommonInterceptorDependencies {
    let sessionProvider: SessionProvider
    let langProvider: LanguagePairProvider
}

final class CommonInterceptor<Request, Response>: ClientInterceptor<Request, Response> {

    let dependencies: CommonInterceptorDependencies
    
    init(_ dependencies: CommonInterceptorDependencies) {
        self.dependencies = dependencies
    }
    
    override func send(_ part: GRPCClientRequestPart<Request>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        switch part {
        case var .metadata(metadata):
            // TODO: Change key for production
            metadata.add(name: "x-api-key", value: "00f098dc-6c8c-4be1-9554-bd61eacd0479_f3c86087-5e28-45ae-98e8-e66badb0bbca")
            
            if let session = dependencies.sessionProvider.currentSid {
                metadata.add(name: dependencies.sessionProvider.sessionKey, value: session.uuidString)
            }
            metadata.add(name: dependencies.langProvider.sourceLangKey, value: dependencies.langProvider.sourceLanguage.rawValue)
            metadata.add(name: dependencies.langProvider.destinationLangKey, value: dependencies.langProvider.destinationLanguage.rawValue)
            
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}
