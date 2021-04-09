//
//  TranslateView.swift
//  YoungSt
//
//  Created by tichenko.r on 03.03.2021.
//

import SwiftUI
import ComposableArchitecture

struct TranslateView: View {
    let store: Store<TranslateState, TranslateAction>
    
    var body: some View {
        ScrollView {
            TranslationView(store: store)
                .padding()
            TranslationResultView(store: store)
                .padding()
            TranslateButtonView(store: store)
                .padding()
        }
    }
}

struct TitleView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.title)
            .lineLimit(nil)
    }
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
