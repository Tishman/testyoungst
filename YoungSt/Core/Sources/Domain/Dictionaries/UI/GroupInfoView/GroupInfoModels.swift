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
import Coordinator

struct GroupInfoState: Equatable {
    
    struct EditState: Equatable {
        var text: String = ""
        var isLoading = false
    }
    
    enum GroupInfo: Equatable {
        case id(UUID)
        case item(DictGroupItem)
    }
    
    let userID: UUID
    var info: GroupInfo
    var editState: EditState?
    
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
    
    var addWordOpened = false
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
    case silentRefreshList
    case closeSceneTriggered
    
    case editTextChanged(String)
    case editCancelled
    case editCommited
    case editFinished(Result<DictGroupItem, EquatableError>)
    
    case updateItems(Result<UpdateItemsResult, EquatableError>)
    case removeGroupResult(Result<Dictionary_RemoveGroupResponse, EquatableError>)
    
    case deleteWordRequested(DictWordItem)
    case deleteWordAlertPressed(DictWordItem)
    
    // this case exists only for animation purposes
    case deleteWordTriggered(DictWordItem)
    
    case wordDeleted(DictionariesAction.DeleteWordResult)
    
    case addWordOpened(Bool)
    case editOpened
    case removeAlertOpened
    case alertClosed
}

struct GroupInfoEnvironment {
    let bag: CancellationBag
    let groupsService: GroupsService
    let userProvider: UserProvider
    let wordsService: WordsService
}
