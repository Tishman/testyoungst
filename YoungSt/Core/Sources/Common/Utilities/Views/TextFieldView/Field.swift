//
//  File.swift
//  
//
//  Created by Роман Тищенко on 22.06.2021.
//

import Foundation

public struct StatusField<T: Equatable>: Equatable {
    public init(value: T, status: TextEditStatus) {
        self.value = value
        self.status = status
    }
    
    public var value: T
    public var status: TextEditStatus
    
    public static func == (lhs: StatusField<T>, rhs: StatusField<T>) -> Bool {
        return lhs.value == rhs.value && lhs.status == rhs.status
    }
}
