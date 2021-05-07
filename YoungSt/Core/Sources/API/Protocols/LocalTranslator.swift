//
//  File.swift
//  
//
//  Created by Nikita Patskov on 06.05.2021.
//

import Foundation
import Combine

public protocol LocalTranslator: AnyObject {
    func isModelExistsForTranslation(from sourceLanguage: Languages, to destinationLanguage: Languages) -> Bool
    func downloadModels(sourceLanguage: Languages, destinationLanguage: Languages) -> AnyPublisher<Void, Error>
    func translate(text: String, from sourceLanguage: Languages, to destinationLanguage: Languages) -> AnyPublisher<String, Error>
}
