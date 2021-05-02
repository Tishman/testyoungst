//
//  File.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import Foundation
import SwiftUI

public extension View {
	@ViewBuilder
	func navigate<Value, Destination: View>(using binding: Binding<Value?>, destination: Destination) -> some View {
		background(NavigationLink(binding, destination: destination))
	}
}
