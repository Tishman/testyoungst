//
//  File.swift
//  
//
//  Created by Nikita Patskov on 01.06.2021.
//

import Foundation

public protocol AuditionService: AnyObject {
    func speak(text: String, language: Languages)
}
