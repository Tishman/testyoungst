//
//  File.swift
//  
//
//  Created by Nikita Patskov on 10.05.2021.
//

import Foundation

public struct DictWordModel: Equatable, Identifiable {
    public init(id: UUID, groupID: UUID, state: DictWordInfo) {
        self.id = id
        self.groupID = groupID
        self.state = state
    }
    
    public let id: UUID
    public let groupID: UUID
    public let state: DictWordInfo
}

public struct DictWordInfo: Equatable {
    public init(text: String, translation: String, info: String) {
        self.text = text
        self.translation = translation
        self.info = info
    }
    
    public let text: String
    public let translation: String
    public let info: String
}
