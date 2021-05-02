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
    
    var addWordState: AddWordState?
    var addGroupState: AddGroupState?
    var groupInfoState: GroupInfoState?
    
    // nil for current user dictionaries
    let userID: UUID?
    
    var groups: [DictGroupItem] = []
    var words: [DictWordItem] = []
    var lastUpdate: String?
    
    var isLoading = false
    var errorAlert: AlertState<DictionariesAction>?
    
    static var preview: DictionariesState = .init(userID: nil,
                                                  groups: [DictGroupItem.preview],
                                                  words: [DictWordItem.preview])
}

enum DictionariesAction: Equatable {
    struct UpdateItemsResult: Equatable {
        let groups: [DictGroupItem]
        let words: [DictWordItem]
    }
    
    case refreshList
    case silentRefreshList
    case viewLoaded
    case itemsUpdated(Result<UpdateItemsResult, EquatableError>)
    case alertClosed
    case addWordOpened(Bool)
    case addGroupOpened(Bool)
    case showAlert(String)
    
    case openGroup(UUID?)
    
    case groupInfo(GroupInfoAction)
    case addWord(AddWordAction)
    case addGroup(AddGroupAction)
}

struct DictionariesEnvironment {
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    let translateService: TranslateService
    let languageProvider: LanguagePairProvider
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    var addWordEnv: AddWordEnvironment {
        .init(translateService: translateService, wordService: wordsService)
    }
    
    var addGroupEnv: AddGroupEnvironment {
        .init(translateService: translateService,
              wordsService: wordsService,
              groupsService: groupsService,
              userProvider: userProvider,
              languageProvider: languageProvider)
    }
    
    var groupInfoEnv: GroupInfoEnvironment {
        .init(groupsService: groupsService,
              userProvider: userProvider)
    }
}
