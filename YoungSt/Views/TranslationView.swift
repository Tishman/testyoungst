//
//  TranslationView.swift
//  YoungSt
//
//  Created by tichenko.r on 15.02.2021.
//

import SwiftUI
import ComposableArchitecture

struct TranslationView: View {
	let store: Store<TranslateState, TranslateAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				HStack(spacing: 40) {
					TitleView(text: viewStore.sourceLanguage.viewModelValue)
                        .fixedSize()
					SwitchButtonView(store: store)
					TitleView(text: viewStore.destinationLanguage.viewModelValue)
                        .fixedSize()
				}
                .padding()
                .border(Color.black)
				TextEditor(text: viewStore.binding(get: \.value, send: TranslateAction.inputTextChanged))
			}
            .border(Color.black)
		}
	}
}
