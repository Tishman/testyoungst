//
//  ModelsExtension.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import Foundation

extension TranslationRequest {
	init(state: TranslateState) {
		self.value = state.value
		self.sourceLanguage = state.from.rawValue
		self.destinationLanguage = state.to.rawValue
	}
}
