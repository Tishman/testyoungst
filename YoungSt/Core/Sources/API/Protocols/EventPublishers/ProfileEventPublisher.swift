//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.06.2021.
//

import Foundation
import Combine

public enum ProfileEvent: Equatable {
    case studentsInfoUpdated
    case teacherInfoUpdated
}

public protocol ProfileEventPublisher: AnyObject {
    
    var publisher: AnyPublisher<ProfileEvent, Never> { get }
    
}
