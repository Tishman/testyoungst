//
//  File.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import Foundation
import Protocols

extension Languages {
    
    public var title: String {
        return Bundle.coreModule.localizedString(forKey: self.rawValue, value: nil, table: "Localizable")
    }
    
}
