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
    
    var isBootstrapping = true
    var sourceFieldForceFocused = false
    var leftToRight = true
    
    var isClosed = false
    var isLoading = false
    var isTranslateLoading = false
    var isAddPending = false
    var changeTranslationAnalyticHandled = false
    
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

enum AddWordAction: Equatable, AnalyticsAction {
    case viewAppeared
    
    case sourceInputFocusChanged(Bool)
    case sourceChanged(String)
    case sourceErrorChanged(String?)
    case translationChanged(String)
    case descriptionChanged(String)
    
    case removeSelectedGroupTriggered
    case swapLanguagesTriggered
    case alertCloseTriggered
    case translateTriggered
    case auditionTriggered
    case addTriggered
    case closeSceneTriggered
    
    case gotTranslation(Result<String, EquatableError>)
    case gotWordAddition(Result<EmptyResponse, EquatableError>)
    case selectedGroupChanged(DictGroupItem?)
    
    case route(Routing)
    
    enum Routing: Equatable, AnalyticsAction {
        case handled
        
        case selectGroup
        
        var event: AnalyticsEvent? {
            switch self {
            case .selectGroup:
                return "selectGroup"
            case .handled:
                return nil
            }
        }
    }
    
    var event: AnalyticsEvent? {
        switch self {
        case .removeSelectedGroupTriggered:
            return "removeSelectedGroupTriggered"
        case .swapLanguagesTriggered:
            return "swapLanguagesTriggered"
        case .alertCloseTriggered:
            return "alertCloseTriggered"
        case .translateTriggered:
            return "translateTriggered"
        case .auditionTriggered:
            return "auditionTriggered"
        case .addTriggered:
            return "addTriggered"
        case let .route(routing):
            return routing.event?.route()
        case let .gotTranslation(result):
            return .init(name: "gotTranslation", parameters: AnalyticParameter.result(result).toDict)
        case let .selectedGroupChanged(item):
            return item == nil ? nil : "selectedGroupChanged"
        case .translationChanged:
            return .init(name: "translationChanged", parameters: nil, oneTimeEvent: true)
        default:
            return nil
        }
    }
}

struct AddWordEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    
    let translationService: TranslationService
    let wordService: WordsService
    let groupsService: GroupsService
    let auditionService: AuditionService
    let analyticsService: AnalyticService
    
    var groupsListEnv: GroupsListEnvironment {
        .init(bag: .autoId(childOf: bag), groupsService: groupsService)
    }
}
