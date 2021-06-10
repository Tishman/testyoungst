//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation
import Combine

public enum DictionaryEvent: Equatable {
    case groupListUpdated
    case wordListUpdated(GroupID)
    
    public enum GroupID: Equatable {
        case any
        case id(UUID)
        
        public init(id: String?) {
            if let idString = id, let uuid = UUID(uuidString: idString) {
                self = .id(uuid)
            } else {
                self = .any
            }
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.any, .any), (.any, .id), (.id, .any):
                return true
            case let (.id(left), .id(right)):
                return left == right
            }
        }
    }
}

public protocol DictionaryEventPublisher: AnyObject {
    
    var dictionaryEventPublisher: AnyPublisher<DictionaryEvent, Never> { get }
    
}
