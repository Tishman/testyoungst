//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation

public struct EmptyResponse: Hashable {}

public func toVoid<T>(_ any: T) -> Void {}
public func toEmpty<T>(_ any: T) -> EmptyResponse { .init() }
