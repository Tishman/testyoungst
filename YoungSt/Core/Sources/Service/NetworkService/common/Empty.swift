//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import SwiftProtobuf

public func toEmpty<T>(_ any: T) -> EmptyResponse { .init() }
public typealias EmptyResponse = Google_Protobuf_Empty
