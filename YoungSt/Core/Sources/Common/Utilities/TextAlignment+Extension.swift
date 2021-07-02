//
//  File.swift
//  
//
//  Created by Роман Тищенко on 24.06.2021.
//

import Foundation
import SwiftUI

public extension TextAlignment {
    var nsTextAligment: NSTextAlignment {
        switch self {
        case .center:
            return .center
        case .leading:
            return .left
        case .trailing:
            return .right
        }
    }
}
