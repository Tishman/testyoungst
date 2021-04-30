//
//  TranslateClientFactory.swift
//  YoungSt
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import GRPC
import NIO

struct TranslatorInjectionInterceptorFactory: Translator_TranslatorClientInterceptorFactoryProtocol {
    
    private let dependencies: CommonInterceptorDependencies
    
    init(dependencies: CommonInterceptorDependencies) {
        self.dependencies = dependencies
    }
    
    func makeTranslateInterceptors() -> [ClientInterceptor<Translator_TranslationRequest, Translator_TranslationResponse>] {
        [CommonInterceptor(dependencies)]
    }
}
