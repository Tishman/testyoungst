//
//  File.swift
//  
//
//  Created by Роман Тищенко on 07.04.2021.
//

import Foundation
import SwiftUI

public extension ColorAsset.Color {
    var swiftuiColor: Color {
        return Color(self)
    }
}

public extension ImageAsset {
    var swiftUI: SwiftUI.Image {
        SwiftUI.Image(name, bundle: .coreModule)
    }
}
