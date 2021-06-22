//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import NetworkService
import ComposableArchitecture

struct InvitesTeacherState: Equatable {
    
    struct Invite: Identifiable, Equatable {
        let id: UUID
        let teacher: ProfileInfo
        
        init(proto: Profile_StudentPerspectiveInvite) throws {
            self.id = try .from(string: proto.invite.inviteID)
            self.teacher = try .init(proto: proto.teacher)
        }
    }
    
    var outcoming: Invite?
    var incoming: IdentifiedArrayOf<Invite> = []
    
    var isEmpty: Bool {
        outcoming == nil && incoming.isEmpty
    }
}

enum InvitesTeacherAction: Equatable {
    case searchTeacherOpened
    case inviteAction(id: UUID, action: InviteAction)
    
    enum InviteAction: Equatable {
        case accept
        case reject
    }
}
