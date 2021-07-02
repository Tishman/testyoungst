//
//  File.swift
//  
//
//  Created by Роман Тищенко on 30.06.2021.
//

import Foundation
import ComposableArchitecture

let codeItemReducer = Reducer<CodeItemState, CodeItemAction, Void> { state, action, _ in
    switch action {
    case let .forcedFocus(isFocused):
        state.forceFocused = isFocused
        
    case .textUpdated, .characterLimitUpdated:
        break
    }
    return .none
}
