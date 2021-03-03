//
//  WordDBModel.swift
//  YoungSt
//
//  Created by tichenko.r on 23.12.2020.
//

import Foundation
import GRDB

struct WordDBModel: DatabaseModelProtocol {
	let id: UUID
	let sourceText: String
	let destinationText: String
	
	init(viewModel: TranslateState.Word) {
		self.id = viewModel.id
		self.sourceText = viewModel.sourceText
		self.destinationText = viewModel.destinationText
	}
}
