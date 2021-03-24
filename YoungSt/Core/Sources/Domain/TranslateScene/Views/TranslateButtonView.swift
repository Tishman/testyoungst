//
//  TranslateButtonView.swift
//  YoungSt
//
//  Created by tichenko.r on 03.03.2021.
//

import SwiftUI
import ComposableArchitecture

public struct TranslateButtonView: View {
    let store: Store<TranslateState, TranslateAction>
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.translateButtonTapped)
            }, label: {
                Text("Translate")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 3)
                    )
            })
        }
    }
}

struct SaveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateButtonView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
