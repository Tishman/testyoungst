//
//  File.swift
//  
//
//  Created by Nikita Patskov on 28.04.2021.
//

import Foundation

public protocol LanguagePairProvider {
    var sourceLanguage: Languages { get }
    var destinationLanguage: Languages { get }
    
    var sourceLangKey: String { get }
    var destinationLangKey: String { get }
}

public struct MockLangProvider: LanguagePairProvider {
    public let sourceLanguage: Languages = .russian
    public let destinationLanguage: Languages = .english
    public let sourceLangKey: String = "sourceLocale"
    public var destinationLangKey: String = "destinationLocale"
    
    public init() {}
}
