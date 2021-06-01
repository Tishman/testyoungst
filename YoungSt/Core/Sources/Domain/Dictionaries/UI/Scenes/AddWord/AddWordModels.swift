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

struct AddWordState: Equatable, Previwable, ClosableState {
    
    struct SelectedGroup: Equatable {
        let id: UUID
        let title: String
    }
    
    enum Routing: Equatable {
        case groupsList(userID: UUID)
    }
    
    let info: AddWordInfo
    let sourceLanguage: Languages
    let destinationLanguage: Languages
    
    var routing: Routing?
    
    var leftToRight = true
    var localTranslationDownloading = false
    
    var isClosed = false
    var isLoading = false
    var isTranslateLoading = false
    
    var sourceText = ""
    var sourceError: String?
    var translationText = ""
    var descriptionText = ""
    var alertError: AlertState<AddWordAction>?
    
    var selectedGroup: SelectedGroup?
    
    var currentSource: Languages {
        leftToRight ? sourceLanguage : destinationLanguage
    }
    
    var currentDestination: Languages {
        leftToRight ? destinationLanguage : sourceLanguage
    }
    
    var editingMode: Bool {
        info.editingWordID != nil
    }
    
    static let preview: AddWordState = .init(info: .preview,
                                             sourceLanguage: .russian,
                                             destinationLanguage: .english,
                                             sourceText: "Hello",
                                             translationText: "Привет",
                                             descriptionText: "",
                                             selectedGroup: .init(id: .init(), title: "Lesson 1"))
}

extension AddWordState {
    init(input: AddWordInput, sourceLanguage: Languages, destinationLanguage: Languages) {
        self.info = .init(input: input)
        if let word = input.model.word {
            sourceText = word.state.text
            translationText = word.state.translation
            descriptionText = word.state.info
        }
        if let group = input.model.group, group.alias != DictGroupItem.rootAlias {
            selectedGroup = .init(id: group.id, title: group.state.title)
        }
        
        self.sourceLanguage = sourceLanguage
        self.destinationLanguage = destinationLanguage
    }
}

struct AddWordInfo: Equatable, Previwable {
    let semantic: AddWordInput.Semantic
    let userID: UUID
    let groupSelectionEnabled: Bool
    let editingWordID: UUID?
    
    static let preview: AddWordInfo = .init(semantic: .addToServer,
                                            userID: .init(),
                                            groupSelectionEnabled: true,
                                            editingWordID: nil)
}

extension AddWordInfo {
    init(input: AddWordInput) {
        self.semantic = input.semantic
        self.userID = input.userID
        self.groupSelectionEnabled = input.groupSelectionEnabled
        self.editingWordID = input.model.word?.id
    }
}

enum AddWordAction: Equatable {
    case sourceChanged(String)
    case sourceErrorChanged(String?)
    case translationChanged(String)
    case descriptionChanged(String)
    case gotTranslation(Result<String, EquatableError>)
    case gotWordAddition(Result<EmptyResponse, EquatableError>)
    case translationDownloaded(Result<EmptyResponse, EquatableError>)
    
    case selectedGroupChanged(DictGroupItem?)
    case viewAppeared
    case removeSelectedGroupPressed
    case swapLanguagesPressed
    case alertClosePressed
    case translatePressed
    case auditionPressed
    case addPressed
    case routingHandled
    
    case groupsOpened
    case closeSceneTriggered
}

struct AddWordEnvironment {
    let bag: CancellationBag
    
    let translationService: TranslationService
    let wordService: WordsService
    let groupsService: GroupsService
    let auditionService: AuditionService
    
    var groupsListEnv: GroupsListEnvironment {
        .init(bag: .autoId(childOf: bag), groupsService: groupsService)
    }
}
