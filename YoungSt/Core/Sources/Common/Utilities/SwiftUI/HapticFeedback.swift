//
//  File.swift
//  
//
//  Created by Nikita Patskov on 09.06.2021.
//

import UIKit

final class HapticTapFeedback {
    
    static let shared = HapticTapFeedback()
    
    private let feedbackGenerator: UIImpactFeedbackGenerator
    
    init() {
        feedbackGenerator = .init(style: .light)
    }
    
    func impactOccured() {
        feedbackGenerator.impactOccurred()
    }
    
}
