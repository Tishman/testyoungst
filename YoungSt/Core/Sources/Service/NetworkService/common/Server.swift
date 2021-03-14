//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

public struct ServerConfiguration {
    public let transferProtocol: String
    public let host: String
    public let port: Int
    
    public var connectivityTimeout: Int = 20
    
    public static let local = Self(transferProtocol: "grpc", host: "localhost", port: 8080)
    public static let stage = Self(transferProtocol: "grpcs", host: "vyoungst.com", port: 443)
    public static let production = Self(transferProtocol: "grpcs", host: "youngst.app", port: 443)
    
    public var isSecure: Bool {
        transferProtocol.hasSuffix("s")
    }
}
