//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import DITranquillity
import Coordinator
import SwiftUI

public final class AuthorizationDIFramework: DIFramework {
    public static func load(container: DIContainer) {
        container.append(part: ModuleDelaration.self)
    }
}
