//
//  File.swift
//  
//
//  Created by Роман Тищенко on 30.06.2021.
//

import ComposableArchitecture

struct CodeEnterState: Equatable {
    var codeItems: IdentifiedArrayOf<CodeItemState>
    var text: String {
        .init(codeItems.flatMap(\.text))
    }
    let codeCount: Int
    
    init(codeCount: Int) {
        self.codeCount = codeCount
        codeItems = .init((0..<codeCount).map({ .init(id: $0)}))
    }
}

enum CodeEnterAction: Equatable {
    case codeItem(id: CodeItemState.ID, action: CodeItemAction)
    case tapTriggered
}
