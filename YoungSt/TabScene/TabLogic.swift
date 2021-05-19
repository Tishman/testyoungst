//
//  TabLogic.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation
import ComposableArchitecture

let tabReducer = Reducer<TabState, TabAction, Void> { state, action, _ in
    switch action {
    case let .selectedTabShanged(selectedId):
        state.selectedTab = selectedId
    case let .addWordOpened(isOpened):
        state.addWordOpened = isOpened
    case .mainButtonPressed:
        state.addWordOpened = true
    }
    return .none
}
