//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation

public struct AnyEquatable<T>: Equatable {
    public let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
}

public typealias EquatableError = AnyEquatable<Error>
extension EquatableError: Error {
    public var description: String {
        return value.localizedDescription
    }
}

extension EquatableError: LocalizedError {
    public var errorDescription: String? {
        value.localizedDescription
    }
}
