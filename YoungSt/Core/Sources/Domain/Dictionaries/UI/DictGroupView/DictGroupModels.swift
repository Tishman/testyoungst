//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities

struct DictGroupItem: Identifiable, Equatable, Previwable {
    static let rootAlias = "root"
    
    let id: UUID
    let alias: String?
    let state: DictGroupState
    
    static let preview: DictGroupItem = .init(id: .init(), alias: nil, state: .preview)
}

struct DictGroupState: Equatable, Previwable {
    let title: String
    let subtitle: String
    
    static let preview: DictGroupState = .init(title: "Lesson 1", subtitle: "12 words")
}
