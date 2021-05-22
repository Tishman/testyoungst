//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources
import Introspect

struct TextEditingView: View {
    let placholder: String
    @Binding var text: String
	var status: TextEditStatus
	@State private var editing = false
    
    var body: some View {
		TextField(placholder, text: $text, onEditingChanged: { self.editing = $0 })
			.textFieldStyle(TextEditStyle(focused: $editing, status: status))
    }
}

struct TextEditingView_Previews: PreviewProvider {
    static var previews: some View {
		TextEditingView(placholder: "Text",
						text: .constant(""),
						status: .default)
    }
}
