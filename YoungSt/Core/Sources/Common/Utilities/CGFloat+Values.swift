//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import CoreGraphics
import UIKit

@usableFromInline let supportsMacIdiom: Bool = !(UIDevice.current.userInterfaceIdiom == .pad)

// https://www.highcaffeinecontent.com/blog/20210516-Supporting-Catalysts-Optimize-for-Mac-with-Manual-Layout
@inlinable public func UIFloat(_ value: CGFloat) -> CGFloat
{
    #if targetEnvironment(macCatalyst)
    return round((value == 0.5) ? 0.5 : value * (supportsMacIdiom ? 0.77 : 1.0))
    #else
    return value
    #endif
}

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
        case custom(CGFloat)
    }
    
    static func spacing(_ level: SpacingLevel) -> CGFloat {
        switch level {
        case .none:
            return UIFloat(0)
        case .ultraSmall:
            return UIFloat(4)
        case .small:
            return UIFloat(8)
        case .medium:
            return UIFloat(12)
        case .regular:
            return UIFloat(16)
        case .big:
            return UIFloat(20)
        case .ultraBig:
            return UIFloat(24)
        case .superBig:
            return UIFloat(28)
        case .extraSize:
            return UIFloat(32)
		case .header:
			return UIFloat(120)
        case let .custom(value):
            return UIFloat(value)
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
            return UIFloat(0)
        case .ultraSmall:
            return UIFloat(4)
        case .small:
            return UIFloat(8)
        case .medium:
            return UIFloat(12)
        case .big:
            return UIFloat(16)
        case .ultraBig:
            return UIFloat(20)
        }
    }
    
}
