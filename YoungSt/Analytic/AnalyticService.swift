//
//  AnalyticService.swift
//  YoungSt
//
//  Created by Nikita Patskov on 30.05.2021.
//

import Foundation
#if !targetEnvironment(macCatalyst) 
import Firebase

final class AnalyticService {
    
    init() {
        FirebaseApp.configure()
    }
    
}

#else
final class AnalyticService {
    init() {}
}
#endif
