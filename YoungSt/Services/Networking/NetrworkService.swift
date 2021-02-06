//
//  NetrworkService.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import Foundation
import Combine
import SwiftProtobuf

protocol NetworkServiceProtocol {
	func sendDataRequest<RequestModel: SwiftProtobuf.Message, ResponseModel: SwiftProtobuf.Message>(url: String, method: HTTPMethod, requestModel: RequestModel) -> AnyPublisher<ResponseModel, Error>
}

final class NetworkService: NetworkServiceProtocol {
	
	func sendDataRequest<RequestModel: SwiftProtobuf.Message, ResponseModel: SwiftProtobuf.Message>(url: String,
																									method: HTTPMethod,
																									requestModel: RequestModel) -> AnyPublisher<ResponseModel, Error> {
		var urlRequest = URLRequest(url: URL(string: url)!)
		urlRequest.httpMethod = method.rawValue
		urlRequest.addValue("00f098dc-6c8c-4be1-9554-bd61eacd0479_f3c86087-5e28-45ae-98e8-e66badb0bbca", forHTTPHeaderField: "x-api-key")
		
		do {
			let httpBody = try requestModel.serializedData()
			urlRequest.httpBody = httpBody
		} catch {
			return Result.failure(NetworkError.failedDataDecode)
				.publisher
				.eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
			.tryMap({ try ResponseModel(serializedData: $0.data) })
			.eraseToAnyPublisher()
	}
}
