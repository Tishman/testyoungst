//
//  File.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import NetworkService
import Utilities

let changePasswordReducer = Reducer<ChangePasswordState, ChangePasswordAction, ChangePasswordEnviroment> { state, action, env in
    func isNotEmptyInput() -> Bool {
        !state.password.isEmpty && !state.confirmPassword.isEmpty
    }
    
    switch action {
    case .fieldSubmitted(.password):
        state.confirmPasswordFieldForceFocused = true
        
    case .fieldSubmitted(.confirmPassword):
        if isNotEmptyInput() {
            return .init(value: .changePasswordButtonTapped)
        } else {
            TextFieldView.hideKeyboard()
        }
        
    case .showPasswordButtonTapped:
        state.isPasswordSecure.toggle()
    
    case .showConfirmPasswordButtonTapped:
        state.isConfirmPasswordSecure.toggle()
    
    case .routingHandled:
        state.routing = nil
        
    case .changePasswordButtonTapped:
        guard ChangePasswordLogic.isFieldNotEmpty(field: state.password) || ChangePasswordLogic.isFieldNotEmpty(field: state.confirmPassword)  else {
            state.alert = ChangePasswordLogic.alert(title: Localizable.fillAllFields, cancelButtonTitle: Localizable.ok)
            break
        }
        guard ChangePasswordLogic.validatePasswordConfrimation(password: state.password, confirm: state.confirmPassword) else {
            state.alert = ChangePasswordLogic.alert(title: Localizable.passwordMismatch, cancelButtonTitle: Localizable.ok)
            break
        }
        
        state.isLoading = true
        
        let requestData = Authorization_ResetPasswordRequest.with {
            $0.email = state.email
            $0.code = state.code
            $0.newPassword = state.password
        }
        
        return env.authorizationService.resetPassword(request: requestData)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(ChangePasswordAction.handleResetPasswordResult)
        
    case let .confirmPasswordUpdated(text):
        state.confirmPassword = text
        
    case let .passswordUpdated(text):
        state.password = text
        
    case let .passwordInputFocusChanged(isFocused):
        state.passwordFieldForceFocused = isFocused
        
    case let .confirmPasswordInputFocusChanged(isFocused):
        state.confirmPasswordFieldForceFocused = isFocused
        
    case .handleResetPasswordResult(.success):
        state.isLoading = false
        state.isPasswordChanged = true
        state.alert = ChangePasswordLogic.alert(title: Localizable.passwordChanged, cancelButtonTitle: Localizable.ok)
        
    case let .handleResetPasswordResult(.failure(error)):
        state.isLoading = false
        state.alert =  ChangePasswordLogic.alert(title: error.localizedDescription, cancelButtonTitle: Localizable.ok)
        
    case .alertOkButtonTapped:
        state.alert = nil
        if state.isPasswordChanged {
            state.routing = .passwordChanged
        }
    }
    return .none
}

struct ChangePasswordLogic {
    static func isFieldNotEmpty(field: String) -> Bool {
        guard !field.isEmpty else { return false }
        return true
    }
    
    static func validatePasswordConfrimation(password: String,
                                             confirm: String) -> Bool {
        guard password == confirm else { return false }
        return true
    }
    
    static func alert(title: String, cancelButtonTitle: String) -> AlertState<ChangePasswordAction> {
        return .init(title: TextState(title), message: nil, dismissButton: .cancel(TextState(cancelButtonTitle)))
    }
}
