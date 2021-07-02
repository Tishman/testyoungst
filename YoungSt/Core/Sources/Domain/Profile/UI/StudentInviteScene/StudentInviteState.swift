//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import ComposableArchitecture
import Utilities
import Resources
import NetworkService
import Coordinator
import Protocols

struct StudentInviteState: Equatable, Previwable, ClosableState {
    
    let invite: SharedInvite
    
    var profileInfo: ProfileInfo?
    
    var isLoading = false
    var title = ""
    var nickname = ""
    var subtitle = ""
    var error: String?
    var actionType = ActionType.requestInvite
    
    var avatarSource: ProfileAvatarSource? {
        profileInfo.map { info in
            ProfileAvatarSource(profileInfo: info)
        }
    }
    
    var isClosed = false
    
    enum ActionType {
        case requestInvite
        case close
    }
    
    static let preview: Self = {
        let id = UUID()
        return .init(invite: SharedInvite(id: 0, password: "asd"),
                     title: "Steve Jobs",
                     nickname: "@stevejobs",
                     subtitle: Localizable.youCantBecomeStudent)
    }()
}

extension StudentInviteState {
    init(input: StudentInviteInput) {
        self.invite = input.invite
    }
}

enum StudentInviteAction: Equatable {
    case viewAppeared
    
    struct CollectInfoResponse: Equatable {
        let teacherProfile: ProfileInfo
        let alreadyHasTeacher: Bool
    }
    
    case infoLoaded(Result<CollectInfoResponse, EquatableError>)
    case sendInvite(Result<EmptyResponse, EquatableError>)
    
    case closeScene
    case performAction
}

struct StudentInviteEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
}
