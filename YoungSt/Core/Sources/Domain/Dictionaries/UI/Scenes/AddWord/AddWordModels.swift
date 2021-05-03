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
import NetworkService
import Combine

struct AddWordState: Equatable, Previwable {
    
    enum Semantic: Equatable {
        case addToServer(closeHandler: (() -> Void)?)
        case addLater
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.addToServer, .addToServer): return true
            case (.addLater, .addLater): return true
            default: return false
            }
        }
    }
    
    let semantic: Semantic
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
    
    static let preview: AddWordState = .init(semantic: .addToServer(closeHandler: nil),
                                             sourceLanguage: .russian,
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
    
    case addLaterTriggered(Dictionary_AddWordRequest)
}

struct AddWordEnvironment {
    let translateService: TranslateService
    let wordService: WordsService
}
