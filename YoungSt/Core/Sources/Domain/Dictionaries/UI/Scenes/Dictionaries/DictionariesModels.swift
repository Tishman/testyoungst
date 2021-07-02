//
//  File.swift
//  
//
//  Created by Nikita Patskov on 28.04.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Protocols
import Coordinator
import NetworkService

struct DictionariesState: Equatable, Previwable {
    
    enum DetailState: Equatable {
        case addGroup(AddGroupState)
        case groupInfo(GroupInfoState)
    }
    
    enum Routing: Equatable {
        case addGroup(userID: UUID)
        case groupInfo(userID: UUID, info: GroupInfoState.GroupInfo)
        case addWord(AddWordInput)
    }
    
    var routing: Routing?
    
    let userID: UUID
    
    var rootGroupID: UUID?
    var groups: [DictGroupItem] = []
    var words: [DictWordItem] = []
    var deletingWords: Set<UUID> = []
    
    var wordsList: [DictWordItem] {
        words.filter { !deletingWords.contains($0.id) }
    }
    
    var lastUpdate: String?
    
    var isLoading = false
    var alert: AlertState<DictionariesAction>?
    
    static var preview: DictionariesState = .init(userID: .init(),
                                                  groups: [DictGroupItem.preview],
                                                  words: [DictWordItem.preview])
}

enum DictionariesAction: Equatable, AnalyticsAction {
    struct UpdateItemsResult: Equatable {
        let groups: [DictGroupItem]
        let words: [DictWordItem]
    }
    
    struct DeleteWordResult: Equatable {
        let deletingID: UUID
        let result: Result<EmptyResponse, EquatableError>
    }
    
    struct UpdateWordsResult: Equatable {
        let result: Result<[DictWordItem], EquatableError>
        let removedID: UUID?
    }
    
    // UI events
    case refreshTriggered
    case viewLoaded
    case alertCloseTriggered
    case deleteWordTriggered(UUID)
    case deleteWordAlertTriggered(UUID)
    
    // Route events
    case route(Routing)
    
    // Logic events
    case updateItems
    case silentUpdateItems
    case itemsUpdated(Result<UpdateItemsResult, EquatableError>)
    case wordsUpdated(UpdateWordsResult)
    case showAlert(String)
    case showLoader(Bool)
    
    // this case exists only for animation purposes
    case deleteWordSubmitted(UUID)
    case wordDeleted(DeleteWordResult)
    
    enum Routing: Equatable, AnalyticsAction {
        case handled
        
        case word(UUID)
        case addWord
        case group(UUID)
        case addGroup
        
        var event: AnalyticsEvent? {
            switch self {
            case .word:
                return "word"
            case .addWord:
                return "addWord"
            case .group:
                return "group"
            case .addGroup:
                return "addGroup"
            case .handled:
                return nil
            }
        }
    }
    
    var event: AnalyticsEvent? {
        switch self {
        case .refreshTriggered:
            return .init(name: CommonEvent.refreshTriggered.rawValue)
        case .alertCloseTriggered:
            return .init(name: CommonEvent.alertClosedTriggered.rawValue)
        case .deleteWordTriggered:
            return "deleteWordRequested"
        case .deleteWordAlertTriggered:
            return "deleteWordAlertPressed"
        case let .route(action):
            return action.event?.route()
        default:
            return nil
        }
    }
}

struct DictionariesEnvironment: AnalyticsEnvironment {
    
    let bag: CancellationBag
    let wordsService: WordsService
    let groupsService: GroupsService
    let translationService: TranslationService
    let userProvider: UserProvider
    let languageProvider: LanguagePairProvider
    let dictionaryEventPublisher: DictionaryEventPublisher
    let analyticsService: AnalyticService
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
