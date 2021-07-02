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

public struct AnalyticsEvent: ExpressibleByStringLiteral {
    
    public var name: String
    public var parameters: [String: Any]?
    public var oneTimeEvent = false
    
    public init(stringLiteral value: StringLiteralType) {
        name = value
    }
    
    public init(name: String, parameters: [String : Any]? = nil, oneTimeEvent: Bool = false) {
        self.name = name
        self.parameters = parameters
        self.oneTimeEvent = oneTimeEvent
    }
    
    public func route() -> AnalyticsEvent {
        prefixed(with: "route")
    }
    
    public func prefixed(with prefix: String) -> AnalyticsEvent {
        var new = self
        new.name = prefix + "_" + name
        return new
    }
    
    public func appending(parameters: [String: Any]) -> AnalyticsEvent {
        var new = self
        new.parameters = (new.parameters ?? [:]).merging(parameters) { $1 }
        return new
    }
}

extension Reducer where Environment: AnalyticsEnvironment, Action: AnalyticsAction {
    public func analytics() -> Reducer<State, Action, Environment> {
        var oneTimeEvents: Set<String> = []
        return .init { state, action, environment in
            if let event = action.event?.prefixed(with: "\(Action.self)"),
               !event.oneTimeEvent || !oneTimeEvents.contains(event.name) {
                environment.analyticsService.log(event: event.name, parameters: event.parameters)
                if event.oneTimeEvent {
                    oneTimeEvents.insert(event.name)
                }
            }
            
            return self.run(&state, action, environment)
        }
    }
}
