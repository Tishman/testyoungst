//
//  File.swift
//  
//
//  Created by Nikita Patskov on 29.04.2021.
//

import Foundation

public protocol UserProvider: AnyObject {
    
    var currentUserID: UUID? { get }
    
}
