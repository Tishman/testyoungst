//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import NetworkService
import GRPC

struct TestCallOptionConfigurator: CallOptionConfigurator {
    let options: CallOptions
    
    func createDefaultCallOptions() -> CallOptions { options }
}
