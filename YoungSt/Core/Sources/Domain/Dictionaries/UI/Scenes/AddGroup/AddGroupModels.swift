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

struct AddGroupState: Equatable, Previwable {
    let userID: UUID?
    
    let tmpID = UUID()
    var addWordState: AddWordState?
    var title: String = ""
    var isLoading = false
    var alertError: AlertState<AddGroupAction>?
    
    var items: [IdentifiedItem<Dictionary_AddWordItem>] = []
    
    static var preview: AddGroupState = .init(userID: nil,
                                              title: "Test name",
                                              items: [Dictionary_AddWordItem](repeating: wordItemPreview, count: 10).map {
                                                .init(id: .init(), item: $0)
                                              })
    private static let wordItemPreview = Dictionary_AddWordItem.with {
        $0.source = "Test"
        $0.destination = "Name"
    }
}

struct IdentifiedItem<T: Equatable>: Identifiable, Equatable {
    let id: UUID
    let item: T
}

enum AddGroupAction: Equatable {
    case titleChanged(String)
    
    case gotAddGroup(Result<Dictionary_AddGroupResponse, EquatableError>)
    
    case addGroupPressed
    case alertClosePressed
    case addWordOpened(Bool)
    
    case showAlert(String)
    case addWord(AddWordAction)
    
    case closeSceneTriggered
}

struct AddGroupEnvironment {
    let translateService: TranslateService
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    
    let languageProvider: LanguagePairProvider
    
    var addWordEnv: AddWordEnvironment {
        .init(translateService: translateService, wordService: wordsService)
    }
}