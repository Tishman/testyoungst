//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities

struct DictGroupState: Identifiable, Equatable, Previwable {
    let id: UUID
    let alias: String?
    let title: String
    let subtitle: String
    
    static let preview: DictGroupState = .init(id: .init(), alias: nil, title: "Lesson 1", subtitle: "12 words")
}
