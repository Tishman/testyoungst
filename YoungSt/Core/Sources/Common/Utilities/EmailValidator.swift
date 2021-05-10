//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.05.2021.
//

import Foundation

public struct EmailValidator {
	public static func isValidEmail(email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
}
