//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture
import GRDB

@main
struct YoungStApp: App {
	let store = Store<AppState, AppAction>.init(initialState: AppState(),
												reducer: appReducer,
												environment: environment)
	
	static var environment: AppEnviroment {
		AppEnviroment(networkService: AppLogic.createNetworkService(),
					  databaseService: AppLogic.createDatabaseService())
	}
	
    var body: some Scene {
        WindowGroup {
			TranslateView(store: self.store.scope(state: \.translateState, action: AppAction.translate(state:)))
        }
    }
}

private struct AppLogic {
	static func createDatabaseService() -> DatabaseServiceProtocol {
		let databaseUrl = try! FileManager.default
			.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			.appendingPathComponent("db.sqlite")
		let dbQueue = try! DatabaseQueue(path: databaseUrl.path)
		let databaseService = try! DatabaseService(dbQueue)
		return databaseService
	}
	
	static func createNetworkService() -> NetworkServiceProtocol {
		return NetworkService()
	}
}

struct AppState: Equatable {
	var translateState: TranslateState = TranslateState()
}

enum AppAction: Equatable {
	case translate(state: TranslateAction)
}

struct AppEnviroment {
	let networkService: NetworkServiceProtocol
	let databaseService: DatabaseServiceProtocol
	
	var translationEnv: TranslateEnviroment {
		.init(networkService: networkService,
			  databaseService: databaseService)
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

 
