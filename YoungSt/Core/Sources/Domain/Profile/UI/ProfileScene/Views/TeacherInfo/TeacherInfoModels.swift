//
//  File.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import NetworkService

struct CurrentTeacher: Equatable {
    let profile: ProfileInfo
    let inviteAccepted: Bool
}
extension ProfileInfo: Previwable {
    static let preview: Self = .init(id: .init(), nickname: "mrakotanski", email: "mrakotanski@apple.com", firstName: "Max", lastName: "Rakotanski")
}
extension CurrentTeacher {
    init(proto: Profile_Teacher) throws {
        self.profile = try .init(proto: proto.profile)
        self.inviteAccepted = proto.inviteAccepted
    }
}

enum TeacherInfoState: Equatable, Previwable {
    case empty
    case error
    case loading
    case exists(CurrentTeacher)
    
    static var preview: Self = .exists(.init(profile: .preview, inviteAccepted: true))
}

enum TeacherInfoAction: Equatable {
    case viewAppeared
    case reload
    case removeTeacher
    
    case teacherLoaded(Result<Profile_GetTeacherResponse, EquatableError>)
    case teacherRemoved(Result<EmptyResponse, EquatableError>)
}

struct TeacherInfoEnvironment {
    let bag: CancellationBag
    
    let inviteService: InviteService
}
