//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation

public enum ModuleLink: Hashable {
    case authorization(AuthorizationInput)
    case dictionaries(DictionariesInput)
}

public enum AuthorizationInput: Identifiable, Hashable {
    case `default`
    
    public var id: Self { return self }
}

public struct DictionariesInput: Hashable {
    public let userID: UUID?
    
    public init(userID: UUID?) {
        self.userID = userID
    }
}
