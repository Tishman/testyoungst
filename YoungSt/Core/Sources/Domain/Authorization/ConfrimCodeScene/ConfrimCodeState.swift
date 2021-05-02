//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation

struct ConfrimCodeState: Equatable {
	var code = ""
	var userId: String
	var isCodeVerified: Bool = false
	var isAlertPresent: Bool = false
	var alertMessage = ""
}
