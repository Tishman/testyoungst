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
		case confirmEmail(ConfirmEmailInput)
	}
    var email: String = ""
    var password: String = ""
    var resetPasswordOpened = false
    var showPassword: Bool = false
    var isLoading = false
	var routing: Routing?
    
    var alertState: AlertState<LoginAction>?
}
