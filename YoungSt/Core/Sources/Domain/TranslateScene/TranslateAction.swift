//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import NetworkService
import Utilities

enum TranslateAction: Equatable {
    case translateButtonTapped
    case switchButtonTapped
    case outputTextChanged(String)
    case inputTextChanged(String)
    case didRecievTranslation(Result<Translator_TranslationResponse, EquatableError>)
    case addWordButtonTapped
    case clearButtonTapped
    case didSaveWord
    case didClearWords
}
