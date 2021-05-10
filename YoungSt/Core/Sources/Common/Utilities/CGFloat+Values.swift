//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import CoreGraphics

public extension CGFloat {
    
    enum SpacingLevel {
        case none
        case ultraSmall
        case small
        case medium
        case regular
        case big
        case ultraBig
        case superBig
        case extraSize
		case header
    }
    
    static func spacing(_ level: SpacingLevel) -> CGFloat {
        switch level {
        case .none:
            return 0
        case .ultraSmall:
            return 4
        case .small:
            return 8
        case .medium:
            return 12
        case .regular:
            return 16
        case .big:
            return 20
        case .ultraBig:
            return 24
        case .superBig:
            return 28
        case .extraSize:
            return 32
		case .header:
			return 120
        }
    }
    
    enum CornerLevel {
        case none
        case ultraSmall
        case small
        case medium
        case big
        case ultraBig
    }
    
    static func corner(_ level: CornerLevel) -> CGFloat {
        switch level {
        case .none:
            return 0
        case .ultraSmall:
            return 4
        case .small:
            return 8
        case .medium:
            return 12
        case .big:
            return 16
        case .ultraBig:
            return 20
        }
    }
    
}
