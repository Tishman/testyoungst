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
import Coordinator

struct AddWordState: Equatable, Previwable {
    
    let input: AddWordInput
    let sourceLanguage: Languages
    let destinationLanguage: Languages
    
    var groupsListState: GroupsListState?
    
    var leftToRight = true
    var localTranslationDownloading = false
    
    var isLoading = false
    var isTranslateLoading = false
    
    var sourceText: String = ""
    var translationText: String = ""
    var descriptionText: String = ""
    var alertError: AlertState<AddWordAction>?
    
    
    var selectedGroupID: UUID?
    
    var currentSource: Languages {
        leftToRight ? sourceLanguage : destinationLanguage
    }
    
    var currentDestination: Languages {
        leftToRight ? destinationLanguage : sourceLanguage
    }
    
    static let preview: AddWordState = .init(input: .init(closeHandler: {}, semantic: .addToServer, userID: .init(), attachToGroupVisible: true),
                                             sourceLanguage: .russian,
                                             destinationLanguage: .english,
                                             sourceText: "Hello",
                                             translationText: "Привет",
                                             descriptionText: "")
}

enum AddWordAction: Equatable {
    case groupsList(GroupsListAction)
    
    case sourceChanged(String)
    case descriptionChanged(String)
    case selectedGroupChanged(UUID?)
    case gotTranslation(Result<String, EquatableError>)
    case gotWordAddition(Result<EmptyResponse, EquatableError>)
    case translationDownloaded(Result<EmptyResponse, EquatableError>)
    
    case viewAppeared
    case swapLanguagesPressed
    case alertClosePressed
    case translatePressed
    case addPressed
    
    case groupsOpened(Bool)
    case closeSceneTriggered
}

struct AddWordEnvironment {
    let translationService: TranslationService
    let wordService: WordsService
    let groupsService: GroupsService
    
    var groupsListEnv: GroupsListEnvironment {
        .init(groupsService: groupsService)
    }
}
