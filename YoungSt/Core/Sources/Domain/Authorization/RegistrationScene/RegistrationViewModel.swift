//
//  File.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import Foundation
import ComposableArchitecture
import NetworkService
import Resources
import Utilities

public struct RegistrationState: Equatable {
    public init(email: String,
                nickname: String,
                password: String) {
        self.email = email
        self.nickname = nickname
        self.password = password
        self.emailPlaceholder = Localizable.emailPlaceholder
        self.nicknamePlaceholder = Localizable.nicknamePlaceholder
        self.passwordPlaceholder = Localizable.passwordPlaceholder
    }
    
    var email: String
    var nickname: String
    var password: String
    let emailPlaceholder: String
    let nicknamePlaceholder: String
    let passwordPlaceholder: String
}

public enum RegistrationAction: Equatable {
    case didEmailChanged(String)
    case didNicknameChange(String)
    case didPasswordChanged(String)
    case registrationButtonTapped
    case didRecieveRegistartionResult(Result<Authorization_RegistrationResponse, EquatableError>)
}

public struct RegistrationEnviroment {
    let client: Authorization_AuthorizationClient?
}

internal let reducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnviroment> { state, action, enviroment in
    switch action {
    case let .didEmailChanged(value):
        state.email = value
        
    case let .didNicknameChange(value):
        state.nickname = value
        
    case let .didPasswordChanged(value):
        state.password = value
        
    case let .didRecieveRegistartionResult(result):
        switch result {
        case let .success(response):
            return .none
        case let .failure(error):
            return .none
        }
        
    case .registrationButtonTapped:
        guard let client = enviroment.client, !state.email.isEmpty, !state.password.isEmpty, !state.nickname.isEmpty else { return .none }
        let requestData = Authorization_RegistrationRequest.with {
            $0.email = state.email
            $0.nickname = state.email
            $0.password = state.password
        }
        
        let registration = client.register(requestData)
        
        return registration
            .response
            .publisher
            .receive(on: DispatchQueue.main)
            .mapError(EquatableError.init)
            .catchToEffect()
            .map({ RegistrationAction.didRecieveRegistartionResult($0) })
    }
    return .none
}
