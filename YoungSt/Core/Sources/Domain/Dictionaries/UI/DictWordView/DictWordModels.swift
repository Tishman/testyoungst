//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities
import Protocols

typealias DictWordItem = DictWordModel
extension DictWordItem: Previwable {
    public static let preview: DictWordModel = .init(id: .init(), groupID: .init(), state: .preview)
}

typealias DictWordState = DictWordInfo
extension DictWordState: Previwable {
    public static let preview: DictWordInfo = .init(text: "Слово очень очень очень очень длинное блин", translation: "Word translation with very very very long content", info: "Note to the word")
}
