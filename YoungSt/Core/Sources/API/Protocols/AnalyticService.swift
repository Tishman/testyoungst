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
    case refreshRequested
    case alertClosed
}

public struct CommonParameter {
    public let key: String
    public let value: Any
    
    public var toDict: [String: Any] {
        [key: value]
    }
}

extension CommonParameter {
    static func result(_ result: Bool) -> CommonParameter { .init(key: "result", value: result) }
    
    static func result<Success, Failure: Error>(_ resultValue: Result<Success, Failure>) -> CommonParameter {
        switch resultValue {
        case .success:
            return result(true)
        case .failure:
            return result(false)
        }
    }
}
