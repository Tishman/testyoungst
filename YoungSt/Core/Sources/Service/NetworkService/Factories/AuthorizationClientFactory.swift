//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import GRPC
import NIO

struct AuthorizationInjectionInterceptorFactory: Authorization_AuthorizationClientInterceptorFactoryProtocol {
    
    private let dependencies: CommonInterceptorDependencies
    
    init(dependencies: CommonInterceptorDependencies) {
        self.dependencies = dependencies
    }
    
    func makeValidateSessionInterceptors() -> [ClientInterceptor<Authorization_ValidateSessionRequest, Authorization_ValidateSessionResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeLoginInterceptors() -> [ClientInterceptor<Authorization_LoginRequest, Authorization_LoginResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeLogoutInterceptors() -> [ClientInterceptor<Authorization_LogoutRequest, Authorization_LogoutResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeRegisterInterceptors() -> [ClientInterceptor<Authorization_RegistrationRequest, Authorization_RegistrationResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeResendCodeInterceptors() -> [ClientInterceptor<Authorization_ResendCodeRequest, Authorization_ResendCodeResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeConfirmCodeInterceptors() -> [ClientInterceptor<Authorization_ConfirmCodeRequest, Authorization_ConfirmCodeResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeInitResetPasswordInterceptors() -> [ClientInterceptor<Authorization_InitResetPasswordRequest, Authorization_InitResetPasswordResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeCheckRestPasswordCodeInterceptors() -> [ClientInterceptor<Authorization_ResetPasswordCheckRequest, Authorization_ResetPasswordCheckResponse>] {
        [CommonInterceptor(dependencies)]
    }
    
    func makeResetPasswordInterceptors() -> [ClientInterceptor<Authorization_ResetPasswordRequest, Authorization_ResetPasswordResponse>] {
        [CommonInterceptor(dependencies)]
    }
}
