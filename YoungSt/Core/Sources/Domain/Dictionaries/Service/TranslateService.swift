//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Combine
import NetworkService

protocol TranslateService: AnyObject {
    func translate(request: Translator_TranslationRequest) -> AnyPublisher<String, Error>
}

final class TranslateServiceImpl: TranslateService {
    
    let client: Translator_TranslatorClientProtocol
    
    init(client: Translator_TranslatorClientProtocol) {
        self.client = client
    }
    
    func translate(request: Translator_TranslationRequest) -> AnyPublisher<String, Error> {
        client.translate(request).response.publisher
            .map { $0.translations.first(where: { !$0.value.isEmpty })?.value ?? "" }
            .eraseToAnyPublisher()
    }
    
}
