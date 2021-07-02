//
//  AnalyticService.swift
//  YoungSt
//
//  Created by Nikita Patskov on 30.05.2021.
//

import Foundation
import Protocols
import Combine

#if !targetEnvironment(macCatalyst) 
import Firebase

final class AnalyticServiceImpl: AnalyticService {
    
    private var bag: Set<AnyCancellable> = []
    
    init(credentialsService: CredentialsService) {
        FirebaseApp.configure()
        
        credentialsService.credentialsUpdated
            .sink(receiveValue: { [weak self] in self?.set(credentials: $0) })
            .store(in: &bag)
    }
    
    func log(event: String, parameters: [String : Any]?) {
        Analytics.logEvent(event, parameters: parameters)
    }
    
    private func set(credentials: Credentials?) {
        Analytics.setUserID(credentials?.userID.uuidString)
    }
    
}

#else
final class AnalyticServiceImpl: AnalyticService {
    init() {}
    
    func log(event: String, parameters: [String : Any]?) {}
}
#endif
