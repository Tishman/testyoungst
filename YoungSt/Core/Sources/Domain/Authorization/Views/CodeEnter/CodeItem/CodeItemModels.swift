//
//  File.swift
//  
//
//  Created by Роман Тищенко on 28.06.2021.
//

import Foundation
import ComposableArchitecture

struct CodeItemState: Equatable, Identifiable {
    let id: Int
    var text: String = ""
    var forceFocused: Bool = false
    var characterLimit: Int = 2
}

enum CodeItemAction: Equatable {
    case textUpdated(String)
    case forcedFocus(Bool)
    case characterLimitUpdated
}
