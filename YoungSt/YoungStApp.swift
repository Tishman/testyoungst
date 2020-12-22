//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture

@main
struct YoungStApp: App {
	let store = Store<TranslateState, TranslateAction>.init(initialState: TranslateState(),
															reducer: translateReducer,
															environment: TranslateEnviroment())
    var body: some Scene {
        WindowGroup {
			MainView(store: store)
        }
    }
}
