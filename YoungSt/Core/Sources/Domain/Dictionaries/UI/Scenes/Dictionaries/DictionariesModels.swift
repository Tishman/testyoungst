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
    
    var addGroupState: AddGroupState?
    var groupInfoState: GroupInfoState?
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
    case addGroupOpened(Bool)
    case showAlert(String)
    case wordSelected(DictWordItem)
    
    case deleteWordRequested(DictWordItem)
    case deleteWordAlertPressed(DictWordItem)
    
    // this case exists only for animation purposes
    case deleteWordTriggered(DictWordItem)
    
    case wordDeleted(DeleteWordResult)
    
    case openGroup(UUID?)
    
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
              userProvider: userProvider)
    }
    
    var addWordEnv: AddWordEnvironment {
        .init(bag: .autoId(childOf: bag),
              translationService: translationService,
              wordService: wordsService,
              groupsService: groupsService)
    }
}
