//
//  TabBarView.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import SwiftUI
import Resources

enum TabItem: Int, CaseIterable, Hashable {
    case dictionaries
    case profile
    
    var title: String {
        switch self {
        case .dictionaries:
            return Localizable.dictionaries
        case .profile:
            return Localizable.profile
        }
    }
    
    var imageName: String {
        switch self {
        case .dictionaries:
            return "rectangle.stack"
        case .profile:
            return "person.circle"
        }
    }
    var accentImageName: String {
        switch self {
        case .dictionaries:
            return "rectangle.stack.fill"
        case .profile:
            return "person.circle.fill"
        }
    }
}
