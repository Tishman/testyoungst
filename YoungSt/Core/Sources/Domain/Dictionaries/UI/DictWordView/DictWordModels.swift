//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities

struct DictWordItem: Identifiable, Equatable, Previwable {
    let id: UUID
    let state: DictWordState
    
    static let preview: DictWordItem = .init(id: .init(), state: .preview)
}

struct DictWordState: Equatable, Previwable {
    let text: String
    let info: String
    
    static var preview: DictWordState = .init(text: "Word", info: "Note to the word")
}
