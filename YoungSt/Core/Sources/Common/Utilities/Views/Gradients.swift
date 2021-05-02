//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.05.2021.
//

import Foundation
import SwiftUI

// https://digitalsynopsis.com/design/beautiful-color-ui-gradients-backgrounds/
public enum Gradients: CaseIterable {
    
    case roseanna
    case sexyBlue
    case piglet
    case lostMemory
    case socialive
    case pinky
    case lush
    case kashmir
    case tranquil
    case greenBeach
    case shalala
    case almost
    case endlessRiver
    case canUFeelLove
    case relay
    
    public init(_ id: UUID) {
        // Associate gradient with id consistently
        let hashValue = Self.consistentHashValue(id: id)
        let allCases = Gradients.allCases
        self = allCases[abs(hashValue % allCases.count)]
    }
    
    
    // Do not use default .hashValue because its vary from launch to launch
    private static func consistentHashValue(id: UUID) -> Int {
        let ids = id.uuid
        var x = ids.0 ^ ids.1 ^ ids.2 ^ ids.3 ^ ids.4 ^ ids.5 ^ ids.6 ^ ids.7
        x = x ^ ids.8 ^ ids.9 ^ ids.10 ^ x ^ ids.11 ^ ids.12 ^ ids.13 ^ ids.14 ^ ids.15
        return Int(x)
    }
    
    public var swiftUI: Gradient {
        switch self {
        case .roseanna:
            return Gradient(colors: [Color(hex: 0xffafbd), Color(hex: 0xffc3a0)])
        case .sexyBlue:
            return Gradient(colors: [Color(hex: 0x2193b0), Color(hex: 0x6dd5ed)])
        case .piglet:
            return Gradient(colors: [Color(hex: 0xee9ca7), Color(hex: 0xffdde1)])
        case .lostMemory:
            return Gradient(colors: [Color(hex: 0xde6262), Color(hex: 0xffb88c)])
        case .socialive:
            return Gradient(colors: [Color(hex: 0x06beb6), Color(hex: 0x48b1bf)])
        case .pinky:
            return Gradient(colors: [Color(hex: 0xdd5e89), Color(hex: 0xf7bb97)])
        case .lush:
            return Gradient(colors: [Color(hex: 0x56ab2f), Color(hex: 0xa8e063)])
        case .kashmir:
            return Gradient(colors: [Color(hex: 0x614385), Color(hex: 0x516395)])
        case .greenBeach:
            return Gradient(colors: [Color(hex: 0x02aab0), Color(hex: 0x00cdac)])
        case .tranquil:
            return Gradient(colors: [Color(hex: 0xeecda3), Color(hex: 0xef629f)])
        case .shalala:
            return Gradient(colors: [Color(hex: 0xd66d75), Color(hex: 0xe29587)])
        case .almost:
            return Gradient(colors: [Color(hex: 0xddd6f3), Color(hex: 0xfaaca8)])
        case .endlessRiver:
            return Gradient(colors: [Color(hex: 0x43cea2), Color(hex: 0x185a9d)])
        case .canUFeelLove:
            return Gradient(colors: [Color(hex: 0x4568dc), Color(hex: 0xb06ab3)])
        case .relay:
            return Gradient(colors: [Color(hex: 0x3a1c71), Color(hex: 0xd76d77), Color(hex: 0xffaf7b)])
        }
    }
    
}
