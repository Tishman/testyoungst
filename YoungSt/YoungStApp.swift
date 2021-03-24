//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture
import GRDB
import NetworkService
import DITranquillity
import TranslateScene

@main
struct YoungStApp: App {
	let store = Store<AppState, AppAction>.init(initialState: AppState(),
												reducer: appReducer,
												environment: environment)
	
	static var environment: AppEnviroment {
		AppEnviroment()
	}
	
    var body: some Scene {
        WindowGroup {
			TranslateView(store: self.store.scope(state: \.translateState, action: AppAction.translate(state:)))
        }
    }
}

private struct AppLogic {}

struct AppState: Equatable {
	var translateState: TranslateState = TranslateState()
}

enum AppAction: Equatable {
	case translate(state: TranslateAction)
}

struct AppEnviroment {
	
	var translationEnv: TranslateEnviroment {
        .init(client: TranslateClientFactory(connectionProvider: ApplicationDI.container.resolve(),
                                             callOptionsProvider: ApplicationDI.container.resolve(),
                                             interceptors: TranslatorInjectionInterceptorFactory())
                .create())
	}
}

let appReducer = Reducer<AppState, AppAction, AppEnviroment>.combine(
	translateReducer.pullback(state: \.translateState,
							  action: /AppAction.translate,
							  environment: \.translationEnv),
	
	Reducer { state, action, env in
		switch action {
		case .translate:
			return .none
		}
	}

)

 
