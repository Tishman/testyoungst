//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import DITranquillity
import Protocols

class CompositeControllerProvider {}
class IndependentControllerProvider {}

public final class DictionaryDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.append(part: DictionaryModuleDeclaration.self)
        container.append(part: AddWordModuleDeclaration.self)
        
        container.register(DictionariesRoutingPoints.init)
        container.register {
            DictionariesController(userID: arg($0), env: $1, routingPoints: $2)
        }
        
        container.register(GroupsListEnvironment.init)
        container.register {
            GroupsListController(userID: arg($0), selectedGroup: arg($1), env: $2)
        }
        
        container.register(AddWordRoutingPoints.init)
        container.register {
            AddWordController(input: arg($0), env: $1, langProvider: $2, routingPoints: $3)
        }
        
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
