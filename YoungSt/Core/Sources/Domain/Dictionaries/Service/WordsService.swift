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
    func removeWord(request: UUID) -> AnyPublisher<EmptyResponse, Error>

    func editWord(request: Dictionary_EditWordRequest) -> AnyPublisher<Dictionary_EditWordResponse, Error>
}

final class WordsServiceImpl: WordsService {
    
    private let client: Dictionary_UserDictionaryClientProtocol
    private let dictEventPublisher: DictionaryEventPublisherImpl
    
    init(client: Dictionary_UserDictionaryClientProtocol, dictEventPublisher: DictionaryEventPublisherImpl) {
        self.client = client
        self.dictEventPublisher = dictEventPublisher
    }
    
    func getUserWords(request: Dictionary_GetUserWordsRequest) -> AnyPublisher<Dictionary_GetUserWordsResponse, Error> {
        client.getUserWords(request).response.publisher.eraseToAnyPublisher()
    }
    
    func addWord(request: Dictionary_AddWordRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.addWord(request).response.publisher
            .map(toEmpty)
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .wordListUpdated(.init(id: request.groupID))) })
            .eraseToAnyPublisher()
    }
    
    func addWordList(request: Dictionary_AddWordListRequest) -> AnyPublisher<Dictionary_AddWordListResponse, Error> {
        client.addWordList(request).response.publisher
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .wordListUpdated(.init(id: request.groupID))) })
            .eraseToAnyPublisher()
    }
    
    func removeWordList(request: Dictionary_RemoveWordListRequest) -> AnyPublisher<EmptyResponse, Error> {
        client.removeWordList(request).response.publisher
            .map(toEmpty)
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .wordListUpdated(.any)) })
            .eraseToAnyPublisher()
    }
    
    func removeWord(request: UUID) -> AnyPublisher<EmptyResponse, Error> {
        let request = Dictionary_RemoveWordListRequest.with {
            $0.idList = [request.uuidString]
        }
        return removeWordList(request: request)
    }
    
    func editWord(request: Dictionary_EditWordRequest) -> AnyPublisher<Dictionary_EditWordResponse, Error> {
        client.editWord(request).response.publisher
            .handleEvents(receiveOutput: { _ in self.dictEventPublisher.send(event: .wordListUpdated(.init(id: request.groupID))) })
            .eraseToAnyPublisher()
    }
}
