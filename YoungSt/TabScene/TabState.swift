//
//  TabState.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation

struct TabState: Equatable {
    let userID: UUID
    
    var selectedTab: TabItem.Identifier = .dictionaries
    var addWordOpened = false
}

enum TabAction: Equatable {
    case selectedTabShanged(TabItem.Identifier?)
    case addWordOpened(Bool)
    case mainButtonPressed
}
