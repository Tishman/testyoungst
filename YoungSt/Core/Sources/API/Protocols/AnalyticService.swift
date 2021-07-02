//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.07.2021.
//

import Foundation

public protocol AnalyticService: AnyObject {
    func log(event: String, parameters: [String: Any]?)
}

public enum CommonEvent: String {
    case refreshTriggered
    case alertClosedTriggered
    case viewLoaded
}

public struct AnalyticParameter {
    public let key: String
    public let value: Any
    
    public var toDict: [String: Any] {
        [key: value]
    }
}

public extension AnalyticParameter {
    static func result(_ result: Bool) -> AnalyticParameter { .init(key: "result", value: result) }
    
    static func result<Success, Failure: Error>(_ resultValue: Result<Success, Failure>) -> AnalyticParameter {
        switch resultValue {
        case .success:
            return result(true)
        case .failure:
            return result(false)
        }
    }
    
    static func editingMode(_ editingMode: Bool) -> AnalyticParameter { .init(key: "editing_mode", value: editingMode) }
}
