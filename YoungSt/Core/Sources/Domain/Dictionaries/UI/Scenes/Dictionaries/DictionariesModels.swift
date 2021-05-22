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

struct DictionariesState: Equatable, Previwable {
    
    enum DetailState: Equatable {
        case addGroup(AddGroupState)
        case groupInfo(GroupInfoState)
    }
    
    var detailState: DetailState?
    
    var addWordState: AddWordState?
    
    let userID: UUID
    
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

extension DictionariesState {
    var addGroupState: AddGroupState? {
        get {
            switch detailState {
            case let .addGroup(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .addGroup:
                detailState = .addGroup(newValue)
            default:
                break
            }
        }
    }
    
    var groupInfoState: GroupInfoState? {
        get {
            switch detailState {
            case let .groupInfo(state):
                return state
            default:
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                detailState = nil
                return
            }
            switch detailState {
            case .groupInfo:
                detailState = .groupInfo(newValue)
            default:
                break
            }
        }
    }
}

enum DictionariesAction: Equatable {
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
    
    case refreshList
    case silentRefreshList
    case viewLoaded
    case itemsUpdated(Result<UpdateItemsResult, EquatableError>)
    case wordsUpdated(UpdateWordsResult)
    case alertClosed
    case addWordOpened(Bool)
    case showAlert(String)
    case wordSelected(DictWordItem)
    
    case deleteWordRequested(DictWordItem)
    case deleteWordAlertPressed(DictWordItem)
    
    // this case exists only for animation purposes
    case deleteWordTriggered(DictWordItem)
    
    case wordDeleted(DeleteWordResult)
    
    case changeDetail(DetailState)
    
    enum DetailState: Equatable {
        case closed
        case group(UUID)
        case addGroup
    }
    
    case groupInfo(GroupInfoAction)
    case addGroup(AddGroupAction)
    case addWord(AddWordAction)
}

struct DictionariesEnvironment {
    
    let bag: CancellationBag
    let wordsService: WordsService
    let groupsService: GroupsService
    let translationService: TranslationService
    let userProvider: UserProvider
    let languageProvider: LanguagePairProvider
    let dictionaryEventPublisher: DictionaryEventPublisher
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    var addGroupEnv: AddGroupEnvironment {
        .init(bag: .autoId(childOf: bag),
              wordsService: wordsService,
              groupsService: groupsService,
              userProvider: userProvider,
              languageProvider: languageProvider)
    }
    
    var groupInfoEnv: GroupInfoEnvironment {
        .init(bag: .autoId(childOf: bag),
              groupsService: groupsService,
              userProvider: userProvider,
              wordsService: wordsService)
    }
    
    var addWordEnv: AddWordEnvironment {
        .init(bag: .autoId(childOf: bag),
              translationService: translationService,
              wordService: wordsService,
              groupsService: groupsService)
    }
}
