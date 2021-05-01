//
//  SizeModifier.swift
//  Procrastiless
//
//  Created by Nikita Packov on 27.04.2020.
//  Copyright © 2020 Nikita Packov. All rights reserved.
//

import SwiftUI

public protocol Preference {
    associatedtype Value
}

public protocol IdentifiedPreference {
    associatedtype Value
    associatedtype ID: Hashable
}

public struct GeometryPreferenceReader<K: PreferenceKey, V>: ViewModifier where K.Value == V {
    public let key: K.Type
    public let value: (GeometryProxy) -> V
    
    public init(key: K.Type, value: @escaping (GeometryProxy) -> V) {
        self.key = key
        self.value = value
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader {
                    Color.clear.preference(key: self.key, value: self.value($0))
                }
            )
    }
}

public struct IdentifiedGeometryPreferenceReader<K: PreferenceKey, ID: Hashable, V> where K.Value == V {
    public let key: K.Type
    public let value: (ID, GeometryProxy) -> V
    
    public init(key: K.Type, value: @escaping (ID, GeometryProxy) -> V) {
        self.key = key
        self.value = value
    }
}


public struct AppendValue<T: Preference>: PreferenceKey {
    public static var defaultValue: [T.Value] { [] }
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
    public typealias Value = [T.Value]
}

public struct AppendUniqueValue<T: IdentifiedPreference>: PreferenceKey {
    public static var defaultValue: [T.ID: T.Value] { [:] }
    
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
    public typealias Value = [T.ID: T.Value]
}

public extension View {
    
    func fetchReaded<K: PreferenceKey, V: Equatable>(_ preference: GeometryPreferenceReader<K, V>, perform: @escaping (V) -> Void) -> some View {
        onPreferenceChange(preference.key, perform: perform)
    }
    
    func fetchReaded<K: PreferenceKey, ID: Hashable, V: Equatable>(_ preference: IdentifiedGeometryPreferenceReader<K, ID, V>, perform: @escaping (V) -> Void) -> some View {
        onPreferenceChange(preference.key, perform: perform)
    }
    
    func read<K: PreferenceKey, V>(_ preference: GeometryPreferenceReader<K, V>) -> some View {
        modifier(preference)
    }
    
    func read<K: PreferenceKey, ID: Hashable, V>(_ preference: IdentifiedGeometryPreferenceReader<K, ID, V>, id: ID) -> some View {
        background(
            GeometryReader {
                Color.clear.preference(key: preference.key, value: preference.value(id, $0))
            }
        )
    }
}
