//
//  File.swift
//  
//
//  Created by Nikita Patskov on 06.05.2021.
//

import Foundation
import Protocols
import Combine
import NetworkService

final class TranslationServiceImpl: TranslationService {
    
    private let client: Translator_TranslatorClientProtocol
    
    init(client: Translator_TranslatorClientProtocol) {
        self.client = client
    }
    
    func translate(text: String, from sourceLanguage: Languages, to destinationLanguage: Languages) -> AnyPublisher<String, Error> {
        guard !text.isEmpty else {
            return Result.success("").publisher.eraseToAnyPublisher()
        }
        let request = Translator_TranslationRequest.with {
            $0.value = text
            $0.destinationLang = destinationLanguage.rawValue
            $0.sourceLang = sourceLanguage.rawValue
        }
        return client.translate(request).response.publisher
            .map { $0.translations.first(where: { !$0.value.isEmpty })?.value ?? "" }
            .eraseToAnyPublisher()
    }
    
}
