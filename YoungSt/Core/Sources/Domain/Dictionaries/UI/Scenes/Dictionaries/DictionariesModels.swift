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
    
    // nil for current user dictionaries
    let userID: UUID?
    
    var groups: [DictGroupState] = []
    var words: [DictWordState] = []
    
    var isLoading = false
    var errorAlert: AlertState<DictionariesAction>?
    
    static var preview: DictionariesState = .init(userID: nil,
                                                  groups: [DictGroupState.preview],
                                                  words: [DictWordState.preview])
}

enum DictionariesAction: Equatable {
    struct UpdateItemsResult: Equatable {
        let groups: [DictGroupState]
        let words: [DictWordState]
    }
    
    case refreshList
    case silentRefreshList
    case viewLoaded
    case itemsUpdated(Result<UpdateItemsResult, EquatableError>)
    case alertClosed
    case addWordOpened(Bool)
    case showAlert(String)
    
    case addWord(AddWordAction)
}

struct DictionariesEnvironment {
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    let translateService: TranslateService
    
    var addWord: AddWordEnvironment {
        .init(translateService: translateService, wordService: wordsService)
    }
}
