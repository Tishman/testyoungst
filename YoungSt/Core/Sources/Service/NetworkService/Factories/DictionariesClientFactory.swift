//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import GRPC

struct DictionariesInjectionInterceptorFactory: Dictionary_UserDictionaryClientInterceptorFactoryProtocol {
    
    private let dependencies: CommonInterceptorDependencies
    
    init(dependencies: CommonInterceptorDependencies) {
        self.dependencies = dependencies
    }
    
    func makeAddGroupInterceptors() -> [ClientInterceptor<Dictionary_AddGroupRequest, Dictionary_AddGroupResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveGroupInterceptors() -> [ClientInterceptor<Dictionary_RemoveGroupRequest, Dictionary_RemoveGroupResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetUserGroupsInterceptors() -> [ClientInterceptor<Dictionary_GetUserGroupsRequest, Dictionary_GetUserGroupsResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeGetUserWordsInterceptors() -> [ClientInterceptor<Dictionary_GetUserWordsRequest, Dictionary_GetUserWordsResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAddWordInterceptors() -> [ClientInterceptor<Dictionary_AddWordRequest, Dictionary_AddWordResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeAddWordListInterceptors() -> [ClientInterceptor<Dictionary_AddWordListRequest, Dictionary_AddWordListResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRemoveWordListInterceptors() -> [ClientInterceptor<Dictionary_RemoveWordListRequest, Dictionary_RemoveWordListResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeEditWordInterceptors() -> [ClientInterceptor<Dictionary_EditWordRequest, Dictionary_EditWordResponse>] {
        [CommonInterceptor(dependencies)]
    }
}
