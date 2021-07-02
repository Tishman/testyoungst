//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import Foundation
import ComposableArchitecture
import Utilities

struct VerificationState: Equatable {
    let email: String
    var isLoading: Bool = false
    var codeEnter: CodeEnterState = .init(codeCount: 6)
    var routing: Routing?
    var alert: AlertState<VerificationAction>?
    
    enum Routing: Equatable {
        case changePassword(email: String, code: String)
    }
}

enum VerificationAction: Equatable {
    case codeEnter(CodeEnterAction)
    case routingHandled
    case sendCodeButtonTapped
    case didRecieveVerificationResult(Result<Bool, EquatableError>)
    case alertOkButtonTapped
    case viewDidAppear
}

struct VerificationEnviroment {
    let authorizationService: AuthorizationService
}
