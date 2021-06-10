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

struct GroupInfoState: Equatable, ClosableState {
    
    struct EditState: Equatable {
        var text: String = ""
        var isLoading = false
    }
    
    enum GroupInfo: Equatable {
        case id(UUID)
        case item(DictGroupItem)
    }
    
    enum Routing: Equatable {
        case addWord(AddWordInput)
    }
    
    let userID: UUID
    var routing: Routing?
    var info: GroupInfo
    var title: String? {
        switch info {
        case let .item(item):
            return item.state.title
        case .id:
            return nil
        }
    }
    var controlsState: ControlsState = .allVisible
    var isClosed = false
    
    var editState: EditState? {
        get {
            guard case let .edit(editState) = controlsState else { return nil }
            return editState
        }
        set {
            guard let newValue = newValue else { return }
            switch controlsState {
            case .edit:
                controlsState = .edit(newValue)
            default:
                break
            }
        }
    }
    
    enum ControlsState: Equatable {
        case edit(EditState)
        case delete(isLoading: Bool)
        case allVisible
        
        var isAllVisible: Bool {
            if case .allVisible = self {
                return true
            }
            return false
        }
    }
    
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
    case showLoader(Bool)
    
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
    
    case routingHandled
    
    case addWordOpened
    case wordSelected(DictWordItem)
    case editOpened
    case deleteOpened
    case deleteClosed
    case alertClosed
}

struct GroupInfoEnvironment {
    let bag: CancellationBag
    let groupsService: GroupsService
    let userProvider: UserProvider
    let wordsService: WordsService
    let dictionaryEventPublisher: DictionaryEventPublisher
}
