//
//  File.swift
//  
//
//  Created by Роман Тищенко on 30.06.2021.
//

import ComposableArchitecture

let codeEnterReducer = Reducer<CodeEnterState, CodeEnterAction, Void>.combine(
    codeItemReducer.forEach(state: \.codeItems, action: /CodeEnterAction.codeItem(id:action:), environment: {}),
    Reducer({ state, action, _ in
        switch action {
//        case let .codeItem(id: id, action: .forcedFocus):
//            state.codeItems[id].characterLimit = id == state.codeCount - 1 ? 1 : 2
            
        case .tapTriggered:
            let indexToFocus = state.codeItems.firstIndex(where: { $0.text.isEmpty }) ?? state.codeItems.count-1
            state.codeItems[indexToFocus].forceFocused = true
        
        case let .codeItem(id: id, action: .textUpdated(text)):
            switch (state.codeItems[id].text.isEmpty, text.isEmpty) {
            case (true, true):
                let previousId = id - 1
                guard previousId >= 0 else { break }
                state.codeItems[previousId].forceFocused = true
                
            case (true, false):
                let nextId = id + 1
                state.codeItems[id].text = text
                guard nextId < state.codeCount else { break }
                state.codeItems[nextId].forceFocused = true
                
            case (false, true):
                let previousId = id - 1
                state.codeItems[id].text = text
                guard previousId >= 0 else { break }
                state.codeItems[previousId].forceFocused = true
                
            case (false, false):
                var currentText = text
                let nextId = id + 1
                state.codeItems[id].text = String(currentText.popLast()!)
                guard nextId < state.codeCount else { break }
                state.codeItems[nextId].forceFocused = true
            }
            
        default: break
        }
        return .none
    })
)
