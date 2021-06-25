//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import DITranquillity

public final class CoordinatorDIFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.register(AppCoordinator.init)
            .as(check: Coordinator.self) {$0}
            .lifetime(.perContainer(.weak))
    }
}
