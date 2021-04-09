//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import GRPC
import NIO

public struct AuthorizationClientFactory: NetworkClientFactory {
    public init(connectionProvider: NetworkConnector,
                callOptionsProvider: CallOptionConfigurator,
                interceptors: Authorization_AuthorizationClientInterceptorFactoryProtocol?) {
        self.connectionProvider = connectionProvider
        self.callOptionsProvider = callOptionsProvider
        self.interceptors = interceptors
    }
    
    public let connectionProvider: NetworkConnector
    public let callOptionsProvider: CallOptionConfigurator
    public let interceptors: Authorization_AuthorizationClientInterceptorFactoryProtocol?
    
    public func create() -> Authorization_AuthorizationClient {
        Authorization_AuthorizationClient(channel: connectionProvider.getConnection(),
                                          defaultCallOptions: callOptionsProvider.createDefaultCallOptions(),
                                          interceptors: interceptors)
    }
}


public struct AuthorizationInjectionInterceptorFactory: Authorization_AuthorizationClientInterceptorFactoryProtocol {
    public init() {}
    
    public func makeValidateSessionInterceptors() -> [ClientInterceptor<Authorization_ValidateSessionRequest, Authorization_ValidateSessionResponse>] {
        [ValidateSessionAPIKeyInjectorInterceptor()]
    }
    
    public func makeLoginInterceptors() -> [ClientInterceptor<Authorization_LoginRequest, Authorization_LoginResponse>] {
        [LoginAPIKeyInjectorInterceptor()]
    }
    
    public func makeLogoutInterceptors() -> [ClientInterceptor<Authorization_LogoutRequest, Authorization_LogoutResponse>] {
        [LogoutAPIKeyInjectorInterceptor()]
    }
    
    public func makeRegisterInterceptors() -> [ClientInterceptor<Authorization_RegistrationRequest, Authorization_RegistrationResponse>] {
        [RegistrationAPIKeyInjectorInterceptor()]
    }
    
    public func makeResendCodeInterceptors() -> [ClientInterceptor<Authorization_ResendCodeRequest, Authorization_ResendCodeResponse>] {
        [ResendCodeAPIKeyInjectorInterceptor()]
    }
    
    public func makeConfirmCodeInterceptors() -> [ClientInterceptor<Authorization_ConfirmCodeRequest, Authorization_ConfirmCodeResponse>] {
        [ConfrimCodeAPIKeyInjectorInterceptor()]
    }
    
    public func makeInitResetPasswordInterceptors() -> [ClientInterceptor<Authorization_InitResetPasswordRequest, Authorization_InitResetPasswordResponse>] {
        [InitResetPasswordAPIKeyInjectorInterceptor()]
    }
    
    public func makeCheckRestPasswordCodeInterceptors() -> [ClientInterceptor<Authorization_ResetPasswordCheckRequest, Authorization_ResetPasswordCheckResponse>] {
        [ResetPasswordCheckAPIKeyInjectorInterceptor()]
    }
    
    public func makeResetPasswordInterceptors() -> [ClientInterceptor<Authorization_ResetPasswordRequest, Authorization_ResetPasswordResponse>] {
        [ResetPasswordAPIKeyInjectorInterceptor()]
    }
    
}

final class ValidateSessionAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_ValidateSessionRequest, Authorization_ValidateSessionResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_ValidateSessionRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_ValidateSessionRequest, Authorization_ValidateSessionResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class LoginAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_LoginRequest, Authorization_LoginResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_LoginRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_LoginRequest, Authorization_LoginResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class LogoutAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_LogoutRequest, Authorization_LogoutResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_LogoutRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_LogoutRequest, Authorization_LogoutResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class RegistrationAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_RegistrationRequest, Authorization_RegistrationResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_RegistrationRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_RegistrationRequest, Authorization_RegistrationResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class ResendCodeAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_ResendCodeRequest, Authorization_ResendCodeResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_ResendCodeRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_ResendCodeRequest, Authorization_ResendCodeResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class ConfrimCodeAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_ConfirmCodeRequest, Authorization_ConfirmCodeResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_ConfirmCodeRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_ConfirmCodeRequest, Authorization_ConfirmCodeResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class InitResetPasswordAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_InitResetPasswordRequest, Authorization_InitResetPasswordResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_InitResetPasswordRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_InitResetPasswordRequest, Authorization_InitResetPasswordResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class ResetPasswordCheckAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_ResetPasswordCheckRequest, Authorization_ResetPasswordCheckResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_ResetPasswordCheckRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_ResetPasswordCheckRequest, Authorization_ResetPasswordCheckResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}

final class ResetPasswordAPIKeyInjectorInterceptor: ClientInterceptor<Authorization_ResetPasswordRequest, Authorization_ResetPasswordResponse> {
    
    override func send(_ part: GRPCClientRequestPart<Authorization_ResetPasswordRequest>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Authorization_ResetPasswordRequest, Authorization_ResetPasswordResponse>) {
        switch part {
        case let .metadata(metadata):
            // TODO: Change key for production
            context.send(.metadata(metadata), promise: promise)
            
        default:
            context.send(part, promise: promise)
        }
    }
}
