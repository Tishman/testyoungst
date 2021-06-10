//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.06.2021.
//

import AVFoundation
import Protocols

final class AuditionServiceImpl: AuditionService {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, language: Languages) {
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = .init(language: language.rawValue)
        
        synthesizer.speak(utterance)
    }
    
}
