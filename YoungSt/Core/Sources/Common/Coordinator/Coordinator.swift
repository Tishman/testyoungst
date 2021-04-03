//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI

public protocol Coordinator {
    func view(for link: ModuleLink) -> AnyView
}
