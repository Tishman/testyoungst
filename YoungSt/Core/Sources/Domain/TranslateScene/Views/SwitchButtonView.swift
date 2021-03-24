//
//  SwitchButtonView.swift
//  YoungSt
//
//  Created by tichenko.r on 22.02.2021.
//

import SwiftUI
import ComposableArchitecture

public struct SwitchButtonView: View {
	let store: Store<TranslateState, TranslateAction>
	
    public var body: some View {
		WithViewStore(store.stateless) { viewStore in
			Button(action: {
				viewStore.send(.switchButtonTapped)
			}) {
				HStack {
					Image("switch")
						.resizable()
						.frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
				}
			}
		}
    }
}
