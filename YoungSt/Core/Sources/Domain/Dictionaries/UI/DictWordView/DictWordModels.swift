//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities

struct DictWordState: Identifiable, Equatable, Previwable {
    let id: UUID
    let text: String
    let info: String
    
    static var preview: DictWordState = .init(id: UUID(), text: "Word", info: "Note to the word")
}
