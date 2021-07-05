//
//  File.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import Foundation
import NetworkService
import Utilities
import Protocols

struct WelcomeEnviroment: AnalyticsEnvironment {
    let analyticsService: AnalyticService
    let authorizationService: AuthorizationService
}
