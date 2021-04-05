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
import Coordinator
import Authorization

@main
struct YoungStApp: App {
    private let container: DIContainer
    private let coordinator: Coordinator
    
	let store = Store<AppState, AppAction>.init(initialState: AppState(),
												reducer: appReducer,
												environment: environment)
    
    init() {
        let container = ApplicationDI.container
        
        self.container = container
        self.coordinator = container.resolve()
    }
	
	static var environment: AppEnviroment {
		AppEnviroment()
	}
	
    var body: some Scene {
        WindowGroup {
            coordinator.view(for: .authorization(.default))
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

 
