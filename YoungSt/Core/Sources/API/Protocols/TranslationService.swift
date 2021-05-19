//
//  File.swift
//  
//
//  Created by Nikita Patskov on 06.05.2021.
//

import Foundation
import Combine

public protocol TranslationService: AnyObject {
    func translate(text: String, from sourceLanguage: Languages, to destinationLanguage: Languages) -> AnyPublisher<String, Error>
}
