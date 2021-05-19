//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import NetworkService

let studentsInfoReducer = Reducer<StudentsInfoState, StudentsInfoAction, StudentsInfoEnvironment>.combine(
    incomingStudentInviteReducer
        .forEach(state: \.studentsInvites, action: /StudentsInfoAction.incomingStudentInvite, environment: \.incomingStudentInviteEnv),
    Reducer { state, action, env in
        
        enum Cancellable: Hashable {
            case updateStudets
            case removeStudent(UUID)
        }
        
        switch action {
        case .viewAppeared:
            return .init(value: .updateList)
            
        case .updateList:
            state.isLoading = true
            
            let request = Profile_GetStudentsRequest()
            return env.inviteService.getStudents(request: request)
                .mapError(EquatableError.init)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(StudentsInfoAction.studentInfoUpdated)
                .cancellable(id: Cancellable.updateStudets, bag: env.bag)
            
        case .alertClosed:
            state.alert = nil
            
        case let .studentInfoUpdated(result):
            state.isLoading = false
            switch result {
            case let .success(studentsResponse):
                let invites = studentsResponse.studentRequests.compactMap { student -> IncomingStudentInviteState? in
                    guard let info = try? ProfileInfo(proto: student.profile) else { return nil }
                    return IncomingStudentInviteState(id: info.id,
                                                      title: info.displayName,
                                                      loading: state.studentsInvites[id: info.id]?.loading)
                }
                state.studentsInvites = .init(invites)
                state.students = studentsResponse.currentStudents.compactMap {
                    try? ProfileInfo(proto: $0.profile)
                }
                
            case let .failure(error):
                state.alert = .init(title: TextState(error.description))
            }
            
        case let .incomingStudentInvite(id, action: .inviteAccepted),
             let .incomingStudentInvite(id, action: .inviteRejected):

            state.studentsInvites.remove(id: id)
            return .init(value: .updateList)
            
        case let .studentOpened(studentID):
            state.openedStudent = studentID
            
        case let .removeStudentTriggered(studentID):
            let request = Profile_RemoveStudentRequest.with {
                $0.studentID = studentID.uuidString
            }
            return env.inviteService.removeStudent(request: request)
                .mapError(EquatableError.init)
                .map { _ in studentID }
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(StudentsInfoAction.studentRemove)
                .cancellable(id: Cancellable.removeStudent(studentID), bag: env.bag)
            
        case let .studentRemove(result):
            switch result {
            case let .success(studentID):
                if let index = state.students.firstIndex(where: { $0.id == studentID }) {
                    state.students.remove(at: index)
                }
                return .init(value: .updateList)
                
            case let .failure(error):
                state.alert = .init(title: TextState(error.description))
            }
            
        case .incomingStudentInvite:
            break
        }
        
        return .none
    }
)
