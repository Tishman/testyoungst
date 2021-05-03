//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation
import Combine

public enum DictionaryEvent {
    case groupListUpdated
    case wordListUpdated
}

public protocol DictionaryEventPublisher: AnyObject {
    
    var dictionaryEventPublisher: AnyPublisher<DictionaryEvent, Never> { get }
    
}
