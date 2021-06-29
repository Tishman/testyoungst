//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.06.2021.
//

import Foundation
import Protocols
import Combine

final class ProfileEventPublisherImpl: ProfileEventPublisher {
    
    var publisher: AnyPublisher<ProfileEvent, Never> {
        profileEventSubject.eraseToAnyPublisher()
    }
    
    private var profileEventSubject: PassthroughSubject<ProfileEvent, Never> = .init()
    
    func send(event: ProfileEvent) {
        profileEventSubject.send(event)
    }
}
