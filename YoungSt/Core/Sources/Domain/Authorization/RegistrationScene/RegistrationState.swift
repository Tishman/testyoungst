//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import ComposableArchitecture

struct RegistrationState: Equatable {
    var email: String = ""
    var nickname: String = ""
    var password: String = ""
    var confrimPassword: String = ""
    var alert: AlertState<RegistrationAction>?
	var confrimCodeState: ConfrimCodeState?
	var isPasswordShowed = false
	var isConfrimPasswordShowed = false
}
