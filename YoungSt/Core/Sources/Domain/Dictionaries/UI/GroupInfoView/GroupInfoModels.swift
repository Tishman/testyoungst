//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import NetworkService
import Protocols

struct GroupInfoState: Equatable {
    
    enum GroupInfo: Equatable {
        case id(UUID)
        case item(DictGroupItem)
    }
    
    var info: GroupInfo
    
    var id: UUID {
        switch info {
        case let .id(id):
            return id
        case let .item(item):
            return item.id
        }
    }
    
    var itemInfo: DictGroupItem? {
        switch info {
        case let .item(item):
            return item
        default:
            return nil
        }
    }
    
    var words: [DictWordItem] = []
    var deletingWords: Set<UUID> = []
    
    var wordsList: [DictWordItem] {
        words.filter { !deletingWords.contains($0.id) }
    }
    
    var isLoading = false
    
    var alert: AlertState<GroupInfoAction>?
}

enum GroupInfoAction: Equatable {
    struct UpdateItemsResult: Equatable {
        let groupItem: DictGroupItem
        let wordsItems: [DictWordItem]
        let deletingGroup: UUID?
    }
    
    case viewAppeared
    case removeGroup
    case refreshList
    case closeSceneTriggered
    
    case updateItems(Result<UpdateItemsResult, EquatableError>)
    case removeGroupResult(Result<Dictionary_RemoveGroupResponse, EquatableError>)
    
    case deleteWordRequested(DictWordItem)
    case deleteWordAlertPressed(DictWordItem)
    
    // this case exists only for animation purposes
    case deleteWordTriggered(DictWordItem)
    
    case wordDeleted(DictionariesAction.DeleteWordResult)
    
    case editOpened(Bool)
    case removeAlertOpened
    case alertClosed
}

struct GroupInfoEnvironment {
    let bag: CancellationBag
    let groupsService: GroupsService
    let userProvider: UserProvider
    let wordsService: WordsService
}
