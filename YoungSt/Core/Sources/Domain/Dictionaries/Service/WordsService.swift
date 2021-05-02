//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import NetworkService
import Utilities
import Combine

public protocol WordsService: AnyObject {
    func getUserWords(request: Dictionary_GetUserWordsRequest) -> AnyPublisher<Dictionary_GetUserWordsResponse, Error>

    func addWord(request: Dictionary_AddWordRequest) -> AnyPublisher<EmptyResponse, Error>

    func addWordList(request: Dictionary_AddWordListRequest) -> AnyPublisher<Dictionary_AddWordListResponse, Error>

    func removeWordList(request: Dictionary_RemoveWordListRequest) -> AnyPublisher<EmptyResponse, Error>

    func editWord(request: Dictionary_EditWordRequest) -> AnyPublisher<Dictionary_EditWordResponse, Error>
}

final class WordsServiceImpl: WordsService {
    
    private let client: Dictionary_UserDictionaryClientProtocol
    
    init(client: Dictionary_UserDictionaryClientProtocol) {
        self.client = client
    }
    
    func getUserWords(request: Dictionary_GetUserWordsRequest) -> AnyPublisher<Dictionary_GetUserWordsResponse, Error> {
        client.getUserWords(request).response.publisher.eraseToAnyPublisher()
    }
    
    func addWord(request: Dictionary_AddWordRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.addWord(request).response.publisher.map(toEmpty).eraseToAnyPublisher()
    }
    
    func addWordList(request: Dictionary_AddWordListRequest) -> AnyPublisher<Dictionary_AddWordListResponse, Error> {
        client.addWordList(request).response.publisher.eraseToAnyPublisher()
    }
    
    func removeWordList(request: Dictionary_RemoveWordListRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.removeWordList(request).response.publisher.map(toEmpty).eraseToAnyPublisher()
    }
    
    func editWord(request: Dictionary_EditWordRequest) -> AnyPublisher<Dictionary_EditWordResponse, Error> {
        client.editWord(request).response.publisher.eraseToAnyPublisher()
    }
}