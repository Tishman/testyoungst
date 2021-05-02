//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import SwiftUI

extension NavigationLink where Label == EmptyView {
	init?<Value>(_ biding: Binding<Value?>, destination: Destination) {
		guard biding.wrappedValue != nil else { return nil }
		
		let isActive = Binding(get: { true },
							   set: { newValue in if !newValue { biding.wrappedValue = nil} })
		self.init(destination: destination, isActive: isActive, label: EmptyView.init)
	}
}
