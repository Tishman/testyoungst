//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import GRPC
import NIO

public protocol NetworkClientFactory {
    associatedtype ClientType
    
    func create() -> ClientType
}
