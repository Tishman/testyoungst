//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import DITranquillity
import Protocols

public final class DictionaryDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.append(part: DictionaryModuleDeclaration.self)
        container.append(part: AddWordModuleDeclaration.self)
        
        container.register(GroupsServiceImpl.init)
            .as(check: GroupsService.self) {$0}
        
        container.register(WordsServiceImpl.init)
            .as(check: WordsService.self) {$0}
        
        container.register(DictionaryEventPublisherImpl.init)
            .as(check: DictionaryEventPublisher.self) {$0}
            .lifetime(.perContainer(.weak))
    }
    
}
