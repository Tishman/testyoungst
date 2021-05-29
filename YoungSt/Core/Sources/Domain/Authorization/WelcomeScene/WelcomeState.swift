//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation

struct WelcomeState: Equatable {
	enum Routing: Equatable {
		case login
		case registration
	}
	
	var routing: Routing?
}
