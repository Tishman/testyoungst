//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI

public enum ModuleLink: Hashable {
    case authorization(AuthorizationInput)
}

public enum AuthorizationInput: Identifiable, Hashable {
    case signIn
    case signUp
    
    public var id: Self { self }
}

private struct CoordinatorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Coordinator = EmptyViewCoordinator()
}

extension EnvironmentValues {
    public var coordinator: Coordinator {
        get { self[CoordinatorEnvironmentKey.self] }
        set { self[CoordinatorEnvironmentKey.self] = newValue }
    }
}

struct EmptyViewCoordinator: Coordinator {
    func view(for link: ModuleLink) -> AnyView {
        .init(EmptyView())
    }
}

