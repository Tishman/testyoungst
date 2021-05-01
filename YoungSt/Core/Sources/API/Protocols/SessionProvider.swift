//
//  File.swift
//  
//
//  Created by Nikita Patskov on 28.04.2021.
//

import Foundation

public protocol SessionProvider: AnyObject {
    var currentSid: UUID? { get }
    
    var sessionKey: String { get }
}
