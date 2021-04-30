//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation

public struct EquatableError: Error, Equatable {
    public init(value: Error) {
        self.value = value
    }
    
    let value: Error
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
    
    public var description: String {
        return value.localizedDescription
    }
}
