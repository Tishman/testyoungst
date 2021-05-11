//
//  CommonDI.swift
//  YoungSt
//
//  Created by Роман Тищенко on 23.03.2021.
//

import Foundation
import DITranquillity
import NetworkService
import Coordinator
import Authorization
import Dictionaries
import Profile
import Protocols
import Translation
import Utilities

final class ApplicationDI: DIFramework {
    static func load(container: DIContainer) {
        
    }
    
    static let container: DIContainer = {
        let container = DIContainer()
        container.append(framework: ApplicationDI.self)
        container.append(framework: NetworkDIFramework.self)
        container.append(framework: AuthorizationDIFramework.self)
        container.append(framework: CoordinatorDIFramework.self)
        container.append(framework: DictionaryDIFramework.self)
        container.append(framework: ProfileDIFramework.self)
        container.append(framework: TranslationServiceDIFramework.self)
        
        container.register {
            CancellationBag.bag(id: UUID())
        }
        container.register(MockLangProvider.init)
            .as(check: LanguagePairProvider.self) {$0}
        
        container.register(AppEnviroment.init)
        
        #if DEBUG
        if !container.makeGraph().checkIsValid(checkGraphCycles: true) {
            fatalError("invalid graph")
        }
        #endif
        
        return container
    }()
}
