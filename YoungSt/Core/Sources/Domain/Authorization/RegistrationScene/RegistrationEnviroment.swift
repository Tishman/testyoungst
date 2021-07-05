//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import NetworkService
import Utilities
import Protocols

struct RegistrationEnviroment: AnalyticsEnvironment {
    let analyticsService: AnalyticService
    let authorizationService: AuthorizationService
}
