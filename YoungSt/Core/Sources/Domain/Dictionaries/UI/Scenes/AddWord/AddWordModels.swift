//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities
import ComposableArchitecture
import Protocols

struct AddWordState: Equatable, Previwable {
    let sourceLanguage: Languages
    let destinationLanguage: Languages
    
    var leftToRight = true
    
    var isLoading = false
    var isTranslateLoading = false
    var groupsOpened = false
    
    var sourceText: String = ""
    var descriptionText: String = ""
    var alertError: AlertState<AddWordAction>?
    
    var selectedGroupID: UUID?
    
    
    var currentSource: Languages {
        leftToRight ? sourceLanguage : destinationLanguage
    }
    
    var currentDestination: Languages {
        leftToRight ? destinationLanguage : sourceLanguage
    }
    
    static let preview: AddWordState = .init(sourceLanguage: .russian,
                                             destinationLanguage: .english,
                                             sourceText: "Hello",
                                             descriptionText: "")
}

enum AddWordAction: Equatable {
    case sourceChanged(String)
    case descriptionChanged(String)
    case selectedGroupChanged(UUID?)
    case gotTranslation(Result<String, EquatableError>)
    case gotWordAddition(Result<EmptyResponse, EquatableError>)
    
    case swapLanguagesPressed
    case alertClosePressed
    case translatePressed
    case addPressed
    
    case groupsOpened(Bool)
    case closeSceneTriggered
}

struct AddWordEnvironment {
    let translateService: TranslateService
    let wordService: WordsService
}
