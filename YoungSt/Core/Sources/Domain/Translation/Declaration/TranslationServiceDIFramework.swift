//
//  File.swift
//  
//
//  Created by Nikita Patskov on 06.05.2021.
//

import Foundation
import DITranquillity
import Protocols

public final class TranslationServiceDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.register(TranslationServiceImpl.init)
            .as(check: TranslationService.self) {$0}
    }
    
}
