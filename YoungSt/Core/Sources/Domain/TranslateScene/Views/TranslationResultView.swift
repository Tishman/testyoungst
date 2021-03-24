//
//  TranslationResultView.swift
//  YoungSt
//
//  Created by tichenko.r on 22.02.2021.
//

import SwiftUI
import ComposableArchitecture

public struct TranslationResultView: View {
	let store: Store<TranslateState, TranslateAction>
	
    public var body: some View {
		WithViewStore(store) { viewStore in
			TextEditor(text: viewStore.binding(get: \.translationResult, send: TranslateAction.outputTextChanged))
                .border(Color.black)
		}
    }
}
