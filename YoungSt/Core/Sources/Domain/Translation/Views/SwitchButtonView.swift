//
//  SwitchButtonView.swift
//  YoungSt
//
//  Created by tichenko.r on 22.02.2021.
//

import SwiftUI
import Utilities
import ComposableArchitecture

struct SwitchButtonView: View {
	let store: Store<TranslateState, TranslateAction>
	
    var body: some View {
		WithViewStore(store.stateless) { viewStore in
			Button(action: {
				viewStore.send(.switchButtonTapped)
			}) {
				HStack {
					Image("switch")
						.resizable()
						.frame(width: UIFloat(24), height: UIFloat(24))
				}
			}
		}
    }
}
