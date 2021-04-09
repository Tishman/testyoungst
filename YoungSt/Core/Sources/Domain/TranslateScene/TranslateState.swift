//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import Resources

struct TranslateState: Equatable {
    var sourceLanguage: Languages = .english
    var destinationLanguage: Languages = .russian
    var value: String = Localizable.inputTranslationPlacholder
    var translationResult: String = Localizable.outputTranslationPlacholder
}
