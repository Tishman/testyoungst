//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import DITranquillity
import Protocols
import UIKit
import Coordinator

public final class DictionaryDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.register(DictionariesRoutingPoints.init)
        container.register(DictionariesEnvironment.init)
        container.register {
            DictionariesController(input: arg($0), env: $1, routingPoints: $2)
        }
        
        // Fod module link
        container.register { env, routingPoints in { input in
            DictionariesController(input: input, env: env, routingPoints: routingPoints).erased
        }}
        
        container.register(GroupsListEnvironment.init)
        container.register {
            GroupsListController(userID: arg($0), selectedGroup: arg($1), env: $2)
        }
        
        container.register(AddWordRoutingPoints.init)
        container.register(AddWordEnvironment.init)
        container.register {
            AddWordController(input: arg($0), env: $1, langProvider: $2, routingPoints: $3)
        }
        
        // Fod module link
        container.register { env, langProvider, routingPoints in { input in
            AddWordController(input: input, env: env, langProvider: langProvider, routingPoints: routingPoints).erased
        }}
        
        container.register(AddGroupEnvironment.init)
        container.register(AddGroupRoutingPoints.init)
        container.register {
            AddGroupController(userID: arg($0), env: $1, routingPoints: $2)
        }
        
        container.register(GroupInfoEnvironment.init)
        container.register(GroupInfoRoutingPoints.init)
        container.register {
            GroupInfoController(userID: arg($0), info: arg($1), env: $2, routingPoints: $3)
        }
        
        container.register(GroupsServiceImpl.init)
            .as(check: GroupsService.self) {$0}
        
        container.register(WordsServiceImpl.init)
            .as(check: WordsService.self) {$0}
        
        container.register(DictionaryEventPublisherImpl.init)
            .as(check: DictionaryEventPublisher.self) {$0}
            .lifetime(.perContainer(.weak))
    }
    
}
