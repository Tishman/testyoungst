//
//  File.swift
//  
//
//  Created by Роман Тищенко on 09.04.2021.
//

import Foundation
import ComposableArchitecture

struct LoginState: Equatable {
    var email: String = ""
    var password: String = ""
    var resetPasswordOpened = false
    var showPassword: Bool = false
    var isLoading = false
    
    var alertState: AlertState<LoginAction>?
}
