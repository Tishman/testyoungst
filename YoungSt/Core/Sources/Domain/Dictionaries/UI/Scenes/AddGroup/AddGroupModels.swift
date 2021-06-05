//
//  File.swift
//  
//
//  Created by Nikita Patskov on 30.04.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import NetworkService
import Protocols
import Coordinator

struct AddGroupState: Equatable, Previwable, ClosableState {
    let userID: UUID
    
    var title: String = ""
    var titleError: String?
    
    var isLoading = false
    var alertError: AlertState<AddGroupAction>?
    var isClosed = false
    
    enum Routing: Equatable {
        case addWord(AddWordInput.InputModel)
    }
    var routing: Routing?
    
    var items: IdentifiedArrayOf<IdentifiedItem<Dictionary_AddWordItem>> = []
    
    static var preview: AddGroupState = .init(userID: .init(),
                                              title: "Test name",
                                              items: .init([Dictionary_AddWordItem](repeating: wordItemPreview, count: 10).map {
                                                .init(id: .init(), item: $0)
                                              }))
    private static let wordItemPreview = Dictionary_AddWordItem.with {
        $0.source = "Test"
        $0.destination = "Name"
    }
}

struct IdentifiedItem<T: Equatable>: Identifiable, Equatable {
    let id: UUID
    var item: T
}

enum AddGroupAction: Equatable {
    case titleChanged(String)
    case titleErrorChanged(String?)
    
    case gotAddGroup(Result<Dictionary_AddGroupResponse, EquatableError>)
    
    case addGroupPressed
    case alertClosePressed
    case addWordOpened
    case rountingHandled
    case wordAdded(AddWordInput.AddLaterRequest)
    
    case wordAction(id: UUID, action: WordAction)
    
    case showAlert(String)
    
    case closeSceneTriggered
    
    enum WordAction: Equatable {
        case selected
        case removed
    }
}

struct AddGroupEnvironment {
    let bag: CancellationBag
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    
    let languageProvider: LanguagePairProvider
}
