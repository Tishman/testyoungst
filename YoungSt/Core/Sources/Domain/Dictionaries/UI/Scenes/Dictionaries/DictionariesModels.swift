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
    var addWordOpened = false
    
    let userID: UUID
    
    var groups: [DictGroupItem] = []
    var rootGroupId: UUID?
    var words: [DictWordItem] = []
    var lastUpdate: String?
    
    var isLoading = false
    var errorAlert: AlertState<DictionariesAction>?
    
    static var preview: DictionariesState = .init(userID: .init(),
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
    case addGroup(AddGroupAction)
}

struct DictionariesEnvironment {
    let wordsService: WordsService
    let groupsService: GroupsService
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
        .init(wordsService: wordsService,
              groupsService: groupsService,
              userProvider: userProvider,
              languageProvider: languageProvider)
    }
    
    var groupInfoEnv: GroupInfoEnvironment {
        .init(groupsService: groupsService,
              userProvider: userProvider)
    }
}
