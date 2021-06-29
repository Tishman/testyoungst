//
//  File.swift
//  
//
//  Created by Nikita Patskov on 28.06.2021.
//

import Foundation
import SwiftUI

public var defaultButtonStyle: some PrimitiveButtonStyle {
    #if targetEnvironment(macCatalyst)
    return PlainButtonStyle()
    #else
    return DefaultButtonStyle()
    #endif
}
