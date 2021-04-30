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
    
    // nil for current user dictionaries
    let userID: UUID?
    
    var groups: [DictGroupItem] = []
    var words: [DictWordItem] = []
    
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
    
    case addWord(AddWordAction)
    case addGroup(AddGroupAction)
}

struct DictionariesEnvironment {
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    let translateService: TranslateService
    let languageProvider: LanguagePairProvider
    
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
}
