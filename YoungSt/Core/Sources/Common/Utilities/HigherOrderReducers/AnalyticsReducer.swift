//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.07.2021.
//

import Foundation
import ComposableArchitecture
import Protocols

public protocol AnalyticsEnvironment {
    var analyticsService: AnalyticService { get }
}

public protocol AnalyticsAction {
    var event: AnalyticsEvent? { get }
}

public enum AnalyticsEvent: ExpressibleByStringLiteral {
    case plain(name: String)
    case parametrized(name: String, parameters: [String: Any])
    
    public init(stringLiteral value: StringLiteralType) {
        self = .plain(name: value)
    }
    
    public func prefixed(with prefix: String) -> AnalyticsEvent {
        switch self {
        case let .plain(name):
            return .plain(name: prefix + "_" + name)
        case let .parametrized(name, parameters):
            return .parametrized(name: prefix + "_" + name, parameters: parameters)
        }
    }
}

extension Reducer where Environment: AnalyticsEnvironment, Action: AnalyticsAction {
    public func
    analytics() -> Reducer<State, Action, Environment> {
        .init { state, action, environment in
            let event = action.event?.prefixed(with: "\(Action.self)")
            switch event {
            case let .plain(name):
                environment.analyticsService.log(event: name, parameters: nil)
            case let .parametrized(name, parameters):
                environment.analyticsService.log(event: name, parameters: parameters)
            case .none:
                break
            }
            return self.run(&state, action, environment)
        }
    }
}
