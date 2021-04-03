//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import GRPC
import NIO
import XCTest
import DITranquillity
import Models
import CombineExpectations
import SwiftLazy
import NIOHPACK
@testable import NetworkService

final class NIOConnectionTests: XCTestCase {
    
    private static let timeLimit: Int64 = 3
    
    private let container: DIContainer = {
        let container = DIContainer()
        
        container.register {
            TestCallOptionConfigurator(options: .init(timeLimit: .timeout(.seconds(NIOConnectionTests.timeLimit))))
        }
        .as(check: CallOptionConfigurator.self) {$0}
        
        container.register {
            GrpcConnector(server: arg($0))
        }
        .as(check: NetworkConnector.self) {$0}
        
        assert(container.makeGraph().checkIsValid(checkGraphCycles: true), "Graph error")
        return container
    }()
    
    private var shouldTestNioCode: Bool {
        return ProcessInfo.processInfo.arguments.contains("-TEST_NIO")
    }
    
    func testGraph() {
        let container = DIContainer()
        container.append(framework: NetworkDIFramework.self)
        
        XCTAssertTrue(container.makeGraph().checkIsValid(checkGraphCycles: true))
    }
    
    func testPlainNIOConnection() throws {
        guard shouldTestNioCode else {
            throw XCTSkip("Comment or provide launch argument to test local connection to docker image")
        }
        let connectorFactory: Provider1<NetworkConnector, ServerConfiguration> = container.resolve()
        let connectionProvider = connectorFactory.value(.local)
        let result = try makeTestConection(connectionProvider: connectionProvider)
        XCTAssertEqual(result, "Привет")
    }
    
    func testSSLNIOConnection() throws {
        guard shouldTestNioCode else {
            throw XCTSkip("Comment or provide launch argument to test remote connection to stage server")
        }
        
        let connectorFactory: Provider1<NetworkConnector, ServerConfiguration> = container.resolve()
        let connectionProvider = connectorFactory.value(.stage)
        let result = try makeTestConection(connectionProvider: connectionProvider)
        XCTAssertEqual(result, "Привет")
    }
    
    func testLoginConnection() throws {
        let connectorFactory: Provider1<NetworkConnector, ServerConfiguration> = container.resolve()
        let connectionProvider = connectorFactory.value(.local)
        let result = try makeAuthTestConnection(connectionProvider: connectionProvider)
        XCTAssertEqual(result, true)
    }
    
    private func makeAuthTestConnection(connectionProvider: NetworkConnector) throws -> Bool {
        let connection = connectionProvider.getConnection()
        let headers = HPACKHeaders([("x-api-key", "00f098dc-6c8c-4be1-9554-bd61eacd0479_f3c86087-5e28-45ae-98e8-e66badb0bbca")])
        let options = CallOptions(customMetadata: headers, timeLimit: .timeout(.seconds(NIOConnectionTests.timeLimit)))
        let client = Authorization_AuthorizationClient(channel: connection,
                                                       defaultCallOptions: options,
                                                       interceptors: nil)
        let requestData = Authorization_LoginRequest.with {
            $0.email = "test@mail.ru"
            $0.password = "123456789"
        }
        
        let login = client.login(requestData)
        
        let exp = expectation(description: #function)
        var result = false
        
        login.response.whenComplete { serverResponse in
            switch serverResponse {
            case .success:
                result = true
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        
        let waitResult = XCTWaiter.wait(for: [exp], timeout: TimeInterval(Self.timeLimit * 2))
        switch waitResult {
        case .completed:
            return result
        default:
            XCTFail("error with wair result \(waitResult)")
            return false
        }
    }
    
    private func makeTestConection(connectionProvider: NetworkConnector) throws -> String? {
        let connection = connectionProvider.getConnection()
        let headers = HPACKHeaders([("x-api-key", "00f098dc-6c8c-4be1-9554-bd61eacd0479_f3c86087-5e28-45ae-98e8-e66badb0bbca")])
        let options = CallOptions(customMetadata: headers, timeLimit: .timeout(.seconds(NIOConnectionTests.timeLimit)))
        let client = Translator_TranslatorClient(channel: connection,
                                                 defaultCallOptions: options,
                                                 interceptors: nil)

        let requestData = Translator_TranslationRequest.with {
            $0.value = "Hello"
            $0.sourceLang = "en"
            $0.destinationLang = "ru"
        }
        
        let translate = client.translate(requestData)
        
        let exp = expectation(description: #function)
        var result: String?
        
        translate.response.whenComplete { serverResponse in
            switch serverResponse {
            case let .success(value):
                result = value.translations.last?.value
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        
        let waitResult = XCTWaiter.wait(for: [exp], timeout: TimeInterval(Self.timeLimit * 2))
        switch waitResult {
        case .completed:
            return result
        default:
            XCTFail("error with wair result \(waitResult)")
            return nil
        }
    }
    
}
