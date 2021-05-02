//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources
import ComposableArchitecture

struct ToggableSecureField: View {
    let placholder: String
    @Binding var text: String
    let showPassword: Bool
    let clouser: () -> Void
    
    var body: some View {
		ZStack(alignment: .trailing) {
			if showPassword {
				TextEditingView(placholder: placholder, text: $text)
			} else {
				SecureField(placholder, text: $text)
					.padding()
					.bubbled(borderColor: Asset.Colors.greenLightly.color.swiftuiColor,
							 foregroundColor: Asset.Colors.greenLightly.color.swiftuiColor,
							 lineWidth: 1)
					.cornerRadius(.corner(.big))
			}
			Button(action: { clouser() }, label: {
				Image(uiImage: showPassword ? Asset.Images.eye.image : Asset.Images.emptyEye.image)
			})
			.offset(x: -.spacing(.big), y: .spacing(.none))
		}
	}
}

struct ToggableSecureField_Previews: PreviewProvider {
    static var previews: some View {
        ToggableSecureField(placholder: "Password", text: .constant(""), showPassword: false, clouser: {})
    }
}
