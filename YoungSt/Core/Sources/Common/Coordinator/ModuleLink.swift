//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import Protocols
import Utilities

public enum ModuleLink: Equatable {
    case authorization(WelcomeInput)
    case dictionaries(DictionariesInput)
    case profile(ProfileInput)
    case addWord(AddWordInput)
    case studentInvite(StudentInviteInput)
}

public struct StudentInviteInput: Equatable {
    public init(invite: SharedInvite) {
        self.invite = invite
    }
    
    public let invite: SharedInvite
}

public struct WelcomeInput: Equatable {
	public init() {}
}

public struct DictionariesInput: Hashable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}

public struct AddWordInput: Equatable {
    
    public struct AddLaterRequest: Equatable {
        public init(id: UUID, sourceText: String, translationText: String, destinationText: String) {
            self.id = id
            self.sourceText = sourceText
            self.translationText = translationText
            self.destinationText = destinationText
        }
        
        public let id: UUID
        public let sourceText: String
        public let translationText: String
        public let destinationText: String
    }
    
    public enum Semantic: Equatable {
        case addToServer
        case addLater(handler: AnyEquatable<(AddLaterRequest) -> Void>)
    }
    
    public struct InputModel: Equatable {
        public init(word: DictWordModel?, group: DictGroupModel?) {
            self.word = word
            self.group = group
        }
        
        public let word: DictWordModel?
        public let group: DictGroupModel?
    }
    
    public init(semantic: Semantic, userID: UUID, groupSelectionEnabled: Bool, model: InputModel = .init(word: nil, group: nil)) {
        self.semantic = semantic
        self.userID = userID
        self.groupSelectionEnabled = groupSelectionEnabled
        self.model = model
    }
    
    public var semantic: Semantic
    public let userID: UUID
    public let groupSelectionEnabled: Bool
    public let model: InputModel
}

public struct ProfileInput: Hashable {
    public let userID: UUID
    
    public init(userID: UUID) {
        self.userID = userID
    }
}
