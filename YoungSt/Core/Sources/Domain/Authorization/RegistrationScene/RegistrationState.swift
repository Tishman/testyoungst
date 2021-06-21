//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import ComposableArchitecture
import Coordinator

struct RegistrationState: Equatable {
	enum Routing: Equatable {
        case confrimEmail(userId: UUID, email: String, password: String)
	}
	
    var email: String = ""
    var nickname: String = ""
    var password: String = ""
    var confrimPassword: String = ""
    var alert: AlertState<RegistrationAction>?
	var isPasswordSecure = true
	var isConfirmSecure = true
	var routing: Routing?
    var isLoading: Bool = false
    var emailFieldForceFocused: Bool = false
    var usernameFieldForceFocused: Bool = false
    var passwordFieldForceFocused: Bool = false
    var confirmPasswordFieldForceFocused: Bool = false
}
