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
    public init(teacherID: UUID) {
        self.teacherID = teacherID
    }
    
    public let teacherID: UUID
}

public struct WelcomeInput: Equatable {
	public init() {}
}

public struct ConfirmEmailInput: Equatable {
	public let userID: UUID
	public let credentials: Credentials
	
	public init(userID: UUID, credentials: Credentials) {
		self.userID = userID
		self.credentials = credentials
	}
	
	public struct Credentials: Equatable {
		public init(email: String, passsword: String) {
			self.email = email
			self.passsword = passsword
		}
		
		public let email: String
		public let passsword: String
	}
}

public struct DictionariesInput: Hashable {
    public let userID: UUID
	public let welcomeMessageShow: Bool
    
    public init(userID: UUID, welcomeMessageShow: Bool) {
        self.userID = userID
		self.welcomeMessageShow = welcomeMessageShow
    }
}

public struct AddWordInput: Equatable {
    
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
    
    public let semantic: Semantic
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
