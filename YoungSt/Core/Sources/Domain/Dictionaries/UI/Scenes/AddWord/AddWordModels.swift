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
    
    struct SelectedGroup: Equatable {
        let id: UUID
        let title: String
    }
    
    let info: AddWordInfo
    let sourceLanguage: Languages
    let destinationLanguage: Languages
    
    var groupsListState: GroupsListState?
    
    var leftToRight = true
    var localTranslationDownloading = false
    
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
    let closeHandler: () -> Void
    let semantic: AddWordInput.Semantic
    let userID: UUID
    let groupSelectionEnabled: Bool
    let editingWordID: UUID?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.semantic == rhs.semantic
            && lhs.userID == rhs.userID
            && lhs.groupSelectionEnabled == rhs.groupSelectionEnabled
    }
    
    static let preview: AddWordInfo = .init(closeHandler: {},
                                            semantic: .addToServer,
                                            userID: .init(),
                                            groupSelectionEnabled: true,
                                            editingWordID: nil)
}

extension AddWordInfo {
    init(input: AddWordInput) {
        self.closeHandler = input.closeHandler
        self.semantic = input.semantic
        self.userID = input.userID
        self.groupSelectionEnabled = input.groupSelectionEnabled
        self.editingWordID = input.model.word?.id
    }
}

enum AddWordAction: Equatable {
    case groupsList(GroupsListAction)
    
    case sourceChanged(String)
    case sourceErrorChanged(String?)
    case descriptionChanged(String)
    case gotTranslation(Result<String, EquatableError>)
    case gotWordAddition(Result<EmptyResponse, EquatableError>)
    case translationDownloaded(Result<EmptyResponse, EquatableError>)
    
    case viewAppeared
    case removeSelectedGroupPressed
    case swapLanguagesPressed
    case alertClosePressed
    case translatePressed
    case addPressed
    
    case groupsOpened(Bool)
    case closeSceneTriggered
}

struct AddWordEnvironment {
    let bag: CancellationBag
    
    let translationService: TranslationService
    let wordService: WordsService
    let groupsService: GroupsService
    
    var groupsListEnv: GroupsListEnvironment {
        .init(bag: .autoId(childOf: bag), groupsService: groupsService)
    }
}
