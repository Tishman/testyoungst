//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation

enum ConfrimCodeAction: Equatable {
	case didCodeStartEnter(String)
	case failedValidation(String)
	case alertPresented
	case didConfrimButtonTapped
	case handleConfrimation(Result<Bool, ConfrimCodeError>)
	case finishRegistartion
}
