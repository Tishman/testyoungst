//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Combine
import NetworkService

public protocol GroupsService: AnyObject {
    
    func addGroup(request: Dictionary_AddGroupRequest) -> AnyPublisher<Dictionary_AddGroupResponse, Error>

    func removeGroup(request: Dictionary_RemoveGroupRequest) -> AnyPublisher<Dictionary_RemoveGroupResponse, Error>

    func getUserGroups(request: Dictionary_GetUserGroupsRequest) -> AnyPublisher<Dictionary_GetUserGroupsResponse, Error>
    
    func editGroup(request: Dictionary_EditGroupRequest) -> AnyPublisher<Dictionary_EditGroupResponse, Error>
    
    func getGroupInfo(request: Dictionary_GetGroupInfoRequest) -> AnyPublisher<Dictionary_GetGroupInfoResponse, Error>
}

final class GroupsServiceImpl: GroupsService {
    
    private let client: Dictionary_UserDictionaryClientProtocol
    private let dictEventPublisher: DictionaryEventPublisherImpl
    
    init(client: Dictionary_UserDictionaryClientProtocol, dictEventPublisher: DictionaryEventPublisherImpl) {
        self.client = client
        self.dictEventPublisher = dictEventPublisher
    }
    
    func addGroup(request: Dictionary_AddGroupRequest) -> AnyPublisher<Dictionary_AddGroupResponse, Error> {
        client.addGroup(request).response.publisher
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .groupListUpdated) })
            .eraseToAnyPublisher()
    }
    
    func removeGroup(request: Dictionary_RemoveGroupRequest) -> AnyPublisher<Dictionary_RemoveGroupResponse, Error> {
        client.removeGroup(request).response.publisher
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .groupListUpdated) })
            .eraseToAnyPublisher()
    }
    
    func getUserGroups(request: Dictionary_GetUserGroupsRequest) -> AnyPublisher<Dictionary_GetUserGroupsResponse, Error> {
        client.getUserGroups(request).response.publisher.eraseToAnyPublisher()
    }
    
    func editGroup(request: Dictionary_EditGroupRequest) -> AnyPublisher<Dictionary_EditGroupResponse, Error> {
        client.editGroup(request).response.publisher
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .groupListUpdated) })
            .eraseToAnyPublisher()
    }
    
    func getGroupInfo(request: Dictionary_GetGroupInfoRequest) -> AnyPublisher<Dictionary_GetGroupInfoResponse, Error> {
        client.getGroupInfo(request).response.publisher.eraseToAnyPublisher()
    }
}
