//
//  LocalTranslationImpl.swift
//  YoungSt
//
//  Created by Nikita Patskov on 06.05.2021.
//

import Foundation
import Protocols
import Combine
import MLKitTranslate


final class LocalTranslationImpl: LocalTranslator {
    
    private let manager = ModelManager.modelManager()
    
    func isModelExistsForTranslation(from sourceLanguage: Languages, to destinationLanguage: Languages) -> Bool {
        return manager.isModelDownloaded(TranslateRemoteModel.translateRemoteModel(language: toMLLanguage(source: sourceLanguage)))
            && manager.isModelDownloaded(TranslateRemoteModel.translateRemoteModel(language: toMLLanguage(source: destinationLanguage)))
    }
    
    func downloadModels(sourceLanguage: Languages, destinationLanguage: Languages) -> AnyPublisher<Void, Error> {
        let options = TranslatorOptions(sourceLanguage: toMLLanguage(source: sourceLanguage),
                                        targetLanguage: toMLLanguage(source: destinationLanguage))
        let translator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)
        
        return Deferred {
            Future { promise in
                translator.downloadModelIfNeeded(with: conditions) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func translate(text: String, from sourceLanguage: Languages, to destinationLanguage: Languages) -> AnyPublisher<String, Error> {
        let options = TranslatorOptions(sourceLanguage: toMLLanguage(source: sourceLanguage),
                                        targetLanguage: toMLLanguage(source: destinationLanguage))
        let translator = Translator.translator(options: options)
        
        return Deferred {
            Future { promise in
                translator.translate(text) { result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let result = result {
                        promise(.success(result))
                    } else {
                        promise(.failure(NSError(domain: "Unknown", code: 0, userInfo: nil)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func toMLLanguage(source: Languages) -> TranslateLanguage {
        switch source {
        case .russian:
            return .russian
        case .english:
            return .english
        }
    }
    
    
}
