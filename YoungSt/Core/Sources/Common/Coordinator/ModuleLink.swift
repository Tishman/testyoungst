//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation

public enum ModuleLink {
    case authorization(AuthorizationInput)
    case dictionaries(DictionariesInput)
    case profile(ProfileInput)
    case addWord(AddWordInput)
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

public struct AddWordInput {
    public init(closeHandler: @escaping () -> Void) {
        self.closeHandler = closeHandler
    }
    
    public let closeHandler: () -> Void
}

public struct ProfileInput: Hashable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
