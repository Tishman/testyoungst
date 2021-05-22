//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 08.04.2021.
//

import SwiftUI
import Resources
import ComposableArchitecture
import Introspect

struct ToggableSecureField: View {
    let placholder: String
    @Binding var text: String
	var status: TextEditStatus
    let isPasswordHidden: Bool
    let clouser: () -> Void
	@State private var editing = false
    
    var body: some View {
		ZStack(alignment: .trailing) {
			if isPasswordHidden {
				TextEditingView(placholder: placholder, text: $text, status: status)
					.introspectTextField {
						$0.textContentType = .password
						$0.isSecureTextEntry = !self.isPasswordHidden
					}
				
			} else {
				TextEditingView(placholder: placholder, text: $text, status: status)
//				SecureField(placholder, text: $text)
//					.padding()
//					.bubbled(borderColor: Asset.Colors.greenLightly.color.swiftuiColor,
//							 foregroundColor: Asset.Colors.greenLightly.color.swiftuiColor,
//							 lineWidth: 1)
//					.cornerRadius(.corner(.big))

			}
			Button(action: { clouser() }, label: {
				Image(uiImage: isPasswordHidden ? Asset.Images.eye.image : Asset.Images.emptyEye.image)
			})
			.offset(x: -.spacing(.big), y: .spacing(.none))
		}
	}
}

struct ToggableSecureField_Previews: PreviewProvider {
    static var previews: some View {
		ToggableSecureField(placholder: "Password", text: .constant(""), status: .success("dsfds"), isPasswordHidden: false, clouser: {})
    }
}
