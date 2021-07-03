//
//  File.swift
//  
//
//  Created by Роман Тищенко on 02.07.2021.
//

import Foundation
import UIKit

public enum YoungstKeyboardType: Int {
    case `default` = 0
    
    case asciiCapable = 1
    
    case numbersAndPunctuation = 2
    
    case URL = 3
    
    case numberPad = 4
    
    case phonePad = 5
    
    case namePhonePad = 6
    
    case emailAddress = 7
    
    @available(iOS 4.1, *)
    case decimalPad = 8
    
    @available(iOS 5.0, *)
    case twitter = 9
    
    @available(iOS 7.0, *)
    case webSearch = 10
    
    @available(iOS 10.0, *)
    case asciiCapableNumberPad = 11
    
    internal var uiKitType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .asciiCapable:
            return .asciiCapable
        case .numbersAndPunctuation:
            return .numbersAndPunctuation
        case .URL:
            return .URL
        case .numberPad:
            return .numberPad
        case .phonePad:
            return .phonePad
        case .namePhonePad:
            return .namePhonePad
        case .emailAddress:
            return .emailAddress
        case .decimalPad:
            return .decimalPad
        case .twitter:
            return .twitter
        case .webSearch:
            return .webSearch
        case .asciiCapableNumberPad:
            return .asciiCapableNumberPad
        }
    }
}
