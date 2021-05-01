//
//  TranslationView.swift
//  YoungSt
//
//  Created by tichenko.r on 15.02.2021.
//

import SwiftUI
import ComposableArchitecture
import Protocols
import Utilities

struct TranslationView: View {
	let store: Store<TranslateState, TranslateAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				HStack(spacing: 40) {
                    TitleView(text: viewStore.sourceLanguage.title)
                        .fixedSize()
					SwitchButtonView(store: store)
					TitleView(text: viewStore.destinationLanguage.title)
                        .fixedSize()
				}
                .padding()
                
				TextEditor(text: viewStore.binding(get: \.value, send: TranslateAction.inputTextChanged))
			}
            .border(Color.black)
		}
	}
}
