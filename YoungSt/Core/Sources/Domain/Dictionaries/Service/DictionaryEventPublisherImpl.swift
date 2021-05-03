//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.05.2021.
//

import Foundation
import Protocols
import Combine

final class DictionaryEventPublisherImpl: DictionaryEventPublisher {
    
    var dictionaryEventPublisher: AnyPublisher<DictionaryEvent, Never> {
        dictionaryEventSubject.eraseToAnyPublisher()
    }
    
    private var dictionaryEventSubject: PassthroughSubject<DictionaryEvent, Never> = .init()
    
    func send(event: DictionaryEvent) {
        dictionaryEventSubject.send(event)
    }
}
