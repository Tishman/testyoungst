//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation

struct RegistrationState: Equatable {
    var email: String = ""
    var nickname: String = ""
    var password: String = ""
    var confrimPassword: String = ""
	var isAlertPresent: Bool = false
	var alertMessage: String = ""
	var confrimCodeState: ConfrimCodeState?
	var isRegistrationSuccess: Bool = false
	var isCodeConfrimed: Bool?
	var isPasswordShowed = false
	var isConfrimPasswordShowed = false
}
