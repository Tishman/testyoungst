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

enum AddGroupAction: Equatable, AnalyticsAction {
    case titleChanged(String)
    case titleErrorChanged(String?)
    
    case addGroupTriggered
    case alertCloseTriggered
    case wordAction(id: UUID, action: WordAction)
    case closeSceneTriggered
    
    case gotAddGroup(Result<Dictionary_AddGroupResponse, EquatableError>)
    case wordAdded(AddWordInput.AddLaterRequest)
    case showAlert(String)
    
    case route(Routing)
    
    enum Routing: Equatable, AnalyticsAction {
        case handled
        
        case addWord
        case editWord(UUID)
        
        var event: AnalyticsEvent? {
            switch self {
            case .addWord:
                return "addWord"
            case .editWord:
                return "editWord"
            case .handled:
                return nil
            }
        }
    }
    
    enum WordAction: Equatable {
        case selected
        case removed
    }
    
    var event: AnalyticsEvent? {
        switch self {
        case .addGroupTriggered:
            return "addGroupTriggered"
        case .titleChanged:
            return .init(name: "titleChanged", oneTimeEvent: true)
        case let .route(routing):
            return routing.event?.route()
        default:
            return nil
        }
    }
}

struct AddGroupEnvironment: AnalyticsEnvironment {
    let bag: CancellationBag
    let wordsService: WordsService
    let groupsService: GroupsService
    let userProvider: UserProvider
    let analyticsService: AnalyticService
    
    let languageProvider: LanguagePairProvider
}
