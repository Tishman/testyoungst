//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation
import DITranquillity

public final class DictionaryDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.append(part: DictionaryModuleDeclaration.self)
        
        container.register(GroupsServiceImpl.init)
            .as(check: GroupsService.self) {$0}
        
        container.register(WordsServiceImpl.init)
            .as(check: WordsService.self) {$0}
        
        container.register(TranslateServiceImpl.init)
            .as(check: TranslateService.self) {$0}
    }
    
}
