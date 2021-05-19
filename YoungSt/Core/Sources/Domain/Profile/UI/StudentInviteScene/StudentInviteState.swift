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

struct StudentInviteState: Equatable, Previwable {
    
    let input: StudentInviteInput
    var teacherID: UUID { input.teacherID }
    var closeHandler: AnyEquatable<(() -> Void)> { input.closeHandler }
    
    var isLoading = false
    var title = ""
    var nickname = ""
    var subtitle = ""
    var error: String?
    var actionType = ActionType.requestInvite
    var avatarSource: ProfileAvatarSource
    
    enum ActionType {
        case requestInvite
        case close
    }
    
    static let preview: Self = {
        let id = UUID()
        return .init(input: .init(teacherID: id, closeHandler: .init {}),
                     title: "Steve Jobs",
                     nickname: "@stevejobs",
                     subtitle: Localizable.youCantBecomeStudent,
                     avatarSource: .init(id: id, title: "SJ"))
    }()
}

extension StudentInviteState {
    init(input: StudentInviteInput) {
        self.input = input
        self.avatarSource = .info(id: input.teacherID, title: "")
    }
}

enum StudentInviteAction: Equatable {
    case viewAppeared
    
    struct CollectInfoResponse: Equatable {
        let teacherProfile: ProfileInfo
        let alreadyHasTeacher: Bool
    }
    
    case infoLoaded(Result<CollectInfoResponse, EquatableError>)
    case sendInvite(Result<Profile_SendInviteToTeacherResponse, EquatableError>)
    
    case closeScene
    case performAction
}

struct StudentInviteEnvironment {
    let bag: CancellationBag
    
    let profileService: ProfileService
    let inviteService: InviteService
}
