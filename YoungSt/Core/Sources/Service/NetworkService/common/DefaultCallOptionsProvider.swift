//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import GRPC

public protocol CallOptionConfigurator {
    func createDefaultCallOptions() -> CallOptions
}

struct AppCallOptionConfigurator: CallOptionConfigurator {
    func createDefaultCallOptions() -> CallOptions {
        return CallOptions(timeLimit: .timeout(.seconds(30)))
    }
}
