//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Utilities
import Protocols

typealias DictGroupItem = DictGroupModel
extension DictGroupItem: Previwable {
    public static let preview: DictGroupModel = .init(id: .init(), alias: nil, state: .preview)
}

typealias DictGroupState = DictGroupInfo
extension DictGroupState: Previwable {
    public static let preview: DictGroupInfo = .init(title: "Lesson 1", subtitle: "12 words")
}
