//
//  File.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import Foundation
import ComposableArchitecture
import Resources
import Utilities
import Coordinator

struct ShareProfileState: Equatable {
    let userID: UUID
    
    var url: String = ""
    
    var shareURL: URL?
}

enum ShareProfileAction: Equatable {
    case viewAppeared
    case copy
    case shareOpened(Bool)
}

struct ShareProfileEnvironment {
    let bag: CancellationBag
    
    let deeplinkService: DeeplinkService
}
