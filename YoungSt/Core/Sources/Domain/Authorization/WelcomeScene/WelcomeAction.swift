//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation

enum WelcomeAction: Equatable {
	case routingHandled(RoutingState)
	
	enum RoutingState: Equatable {
		case login
		case registration
		case close
	}
}
