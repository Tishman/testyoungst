//
//  TabState.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation

struct TabState: Equatable {
    let userID: UUID
    
    var selectedTab: TabItem = .dictionaries
    var addWordOpened = false
	var welcomeMessageShow = false
}

enum TabAction: Equatable {
    case selectedTabShanged(TabItem?)
    case addWordOpened(Bool)
    case mainButtonPressed
}
