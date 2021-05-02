//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 16.04.2021.
//

import SwiftUI
import Resources

struct ToggableTextEditingView: View {
	let placholder: String
	@Binding var text: String
	
    var body: some View {
		ZStack(alignment: .trailing) {
			TextEditingView(placholder: placholder, text: $text)
			if !text.isEmpty {
				Button(action: {
					text = ""
				}, label: {
					Image(uiImage: Asset.Images.cross.image)
				})
				.offset(x: -.spacing(.big), y: .spacing(.none))
				
			}
		}
    }
}

struct ToggableTextEditingView_Previews: PreviewProvider {
    static var previews: some View {
		ToggableTextEditingView(placholder: "Text", text: .constant(""))
    }
}
