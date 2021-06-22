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
        .forEach(state: \.incomingInvites, action: /StudentsInfoAction.incomingStudentInvite, environment: \.incomingStudentInviteEnv),
    
    outcomingStudentInviteReducer
        .forEach(state: \.outcomingInvites, action: /StudentsInfoAction.outcomingStudentInvite, environment: \.outcomingStudentInviteEnv),
    
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
            
            return env.inviteService.getStudents()
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
                let incomingInvites = studentsResponse.incomingStudentRequests.compactMap { request -> IncomingStudentInviteState? in
                    guard let info = try? ProfileInfo(proto: request.student),
                          let inviteID = try? UUID.from(string: request.invite.inviteID)
                    else { return nil }
                    return IncomingStudentInviteState(id: inviteID,
                                                      title: info.primaryField,
                                                      loading: state.incomingInvites[id: info.id]?.loading)
                }
                
                let outcomingInvites = studentsResponse.outcomingStudentRequests.compactMap { request -> OutcomingStudentInviteState? in
                    guard let info = try? ProfileInfo(proto: request.student),
                          let inviteID = try? UUID.from(string: request.invite.inviteID)
                    else { return nil }
                    return OutcomingStudentInviteState(id: inviteID,
                                                       profile: info,
                                                       isLoading: state.outcomingInvites[id: info.id]?.isLoading ?? false)
                }
                
                let students = studentsResponse.currentStudents.compactMap {
                    try? ProfileInfo(proto: $0.profile)
                }
                
                state.incomingInvites = .init(incomingInvites)
                state.outcomingInvites = .init(outcomingInvites)
                state.students = .init(students)
                
            case let .failure(error):
                state.alert = .init(title: TextState(error.description))
            }
            
        case let .incomingStudentInvite(id, action: .inviteAccepted),
             let .incomingStudentInvite(id, action: .inviteRejected):

            state.incomingInvites.remove(id: id)
            return .init(value: .updateList)
            
        case let .student(studentID, .remove):
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
            
        case .student(_, .open):
            break
            
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
            
        case .incomingStudentInvite, .outcomingStudentInvite, .searchStudentsOpened:
            break
        }
        
        return .none
    }
)
