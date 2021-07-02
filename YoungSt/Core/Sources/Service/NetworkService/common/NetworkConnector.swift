//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import GRPC
import Utilities
import Foundation

public protocol NetworkConnector {
    func getConnection() -> ClientConnection
}

final class GrpcConnector: NetworkConnector {
    
    private let server: ServerConfiguration
    
    private let mutex: ScopedMutex = UnfairLock()
    private var connection: ClientConnection?
    
    init(server: ServerConfiguration) {
        self.server = server
    }
    
    /// Create new connection for grpc server accessing
    func getConnection() -> ClientConnection {
        return mutex.sync {
            if let connection = connection {
                return connection
                
            } else {
                let connection = instantiateConnection()
                self.connection = connection
                return connection
            }
        }
    }
    
    private func instantiateConnection() -> ClientConnection {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .best)
        var connectionConfig = ClientConnection.Configuration.default(target: .hostAndPort(server.host, server.port),
                                                                      eventLoopGroup: group)
        connectionConfig.tls = server.isSecure ? .init() : nil
        connectionConfig.connectionIdleTimeout = .seconds(10)
        return ClientConnection(configuration: connectionConfig)
    }
    
}
