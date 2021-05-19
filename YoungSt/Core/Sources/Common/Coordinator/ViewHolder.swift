//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI

public class StoreHolder<T>: ObservableObject {
    internal init(store: T) {
        self.store = store
    }
    
    public let store: T
}

public protocol ModuleStoreProvider {
    associatedtype T
    
    func createInitialModuleStore() -> T
}

public struct ViewHolder<StoreProvider: ModuleStoreProvider, Content: View>: View {
    
    @StateObject public var store: StoreHolder<StoreProvider.T>
    
    private let content: Content
    
    public init(storeProvider: StoreProvider, @ViewBuilder content: (StoreProvider.T) -> Content) {
        let store = storeProvider.createInitialModuleStore()
        self._store = .init(wrappedValue: .init(store: store))
        self.content = content(store)
    }
    
    public var body: some View {
        content
    }
    
}
