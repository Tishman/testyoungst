//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import Protocols

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
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}

public struct AddWordInput: Equatable {
    
    public static func == (lhs: AddWordInput, rhs: AddWordInput) -> Bool {
        true
    }
    
    public struct AddLaterRequest: Equatable {
        public init(sourceText: String, translationText: String, destinationText: String) {
            self.sourceText = sourceText
            self.translationText = translationText
            self.destinationText = destinationText
        }
        
        public let sourceText: String
        public let translationText: String
        public let destinationText: String
    }
    
    public enum Semantic: Equatable {
        case addToServer
        case addLater(handler: (AddLaterRequest) -> Void)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.addToServer, .addToServer): return true
            case (.addLater, .addLater): return true
            default: return false
            }
        }
    }
    
    public struct InputModel: Equatable {
        public init(word: DictWordModel, group: DictGroupModel?) {
            self.word = word
            self.group = group
        }
        
        public let word: DictWordModel
        public let group: DictGroupModel?
    }
    
    public init(closeHandler: @escaping () -> Void, semantic: Semantic, userID: UUID, groupSelectionEnabled: Bool, model: InputModel? = nil) {
        self.closeHandler = closeHandler
        self.semantic = semantic
        self.userID = userID
        self.groupSelectionEnabled = groupSelectionEnabled
        self.model = model
    }
    
    public let closeHandler: () -> Void
    public let semantic: Semantic
    public let userID: UUID
    public let groupSelectionEnabled: Bool
    public let model: InputModel?
}

public struct ProfileInput: Hashable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
