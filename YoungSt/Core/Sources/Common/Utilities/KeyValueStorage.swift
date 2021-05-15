//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.05.2021.
//

import Foundation

public protocol Storable {
    associatedtype StorableValue
    var storableValue: StorableValue { get }
    static func fromStorableValue(value: StorableValue) throws -> Self
}
public extension Storable where StorableValue == Self {
    static func fromStorableValue(value: StorableValue) throws -> Self {
        value
    }
    var storableValue: StorableValue { self }
}

extension Int: Storable {
    public typealias StorableValue = Int
}
extension String: Storable {
    public typealias StorableValue = String
}
extension Float: Storable {
    public typealias StorableValue = Float
}
extension Double: Storable {
    public typealias StorableValue = Double
}
public struct StorableCodable<T: Codable>: Storable {
    public typealias StorableValue = Data
    public let value: T
    public var storableValue: Data { try! encoder.encode(value) }
    
    public static func fromStorableValue(value: Data) throws -> StorableCodable<T> {
        try .init(value: decoder.decode(T.self, from: value))
    }
}
private let encoder = JSONEncoder()
private let decoder = JSONDecoder()


public protocol KeyValueStorage: AnyObject {
    subscript<T: Storable>(key: String) -> T? { get set }
}

public extension KeyValueStorage {
    subscript<T: RawRepresentable>(key: String) -> T? where T.RawValue: Storable {
        get {
            guard let value: T.RawValue = self[key] else { return nil }
            return .init(rawValue: value)
        }
        set {
            self[key] = newValue?.rawValue
        }
    }
}

extension UserDefaults: KeyValueStorage {
    public subscript<T: Storable>(key: String) -> T? {
        get {
            guard let value = self.object(forKey: key) as? T.StorableValue else {
                return nil
            }
            return try? .fromStorableValue(value: value)
        }
        set {
            self.setValue(newValue?.storableValue, forKey: key)
        }
    }
}
