//
//  File.swift
//  
//
//  Created by Роман Тищенко on 30.06.2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CodeEnterView: View {
    let store: Store<CodeEnterState, CodeEnterAction>
    
    var body: some View {
        HStack {
            ForEachStore(store.scope(state: \.codeItems, action: CodeEnterAction.codeItem), content: CodeItem.init)
        }
        .padding()
        .overlay(
            WithViewStore(store.stateless) { viewStore in
                Color.white.opacity(0.01)
                    .onTapGesture { viewStore.send(.tapTriggered) }
            }
        )
    }
}
