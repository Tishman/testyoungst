//
//  File.swift
//  
//
//  Created by Nikita Patskov on 10.05.2021.
//

import Foundation

public struct DictGroupModel: Identifiable, Equatable {
    public init(id: UUID, alias: String?, state: DictGroupInfo) {
        self.id = id
        self.alias = alias
        self.state = state
    }
    
    public static let rootAlias = "root"
    
    public let id: UUID
    public let alias: String?
    public let state: DictGroupInfo
}

public struct DictGroupInfo: Equatable {
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public let title: String
    public let subtitle: String
}
