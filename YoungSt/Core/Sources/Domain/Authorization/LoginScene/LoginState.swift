//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import ComposableArchitecture
import Coordinator

struct LoginState: Equatable {
	enum Routing: Equatable {
		case forgotPassword
        case confirmEmail(userId: UUID, email: String, password: String)
	}
    var email: String = ""
    var password: String = ""
    var resetPasswordOpened = false
    var isSecure: Bool = false
    var isLoading = false
	var routing: Routing?
    var loginFieldForceFocused: Bool = false
    var passwordFieldForceFocused: Bool = false
    
    var alertState: AlertState<LoginAction>?
}
