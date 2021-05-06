//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 16.04.2021.
//

import SwiftUI
import Resources

struct ClearTextEditingView: View {
	let placholder: String
	@Binding var text: String
	var status: TextEditStatus
	
    var body: some View {
		VStack(alignment: .leading) {
			ZStack(alignment: .trailing) {
				TextEditingView(placholder: placholder,
								text: $text,
								status: status)
				if !text.isEmpty {
					Button(action: {
						text = ""
					}, label: {
						Image(uiImage: Asset.Images.cross.image)
							.renderingMode(.template)
							.foregroundColor(status.iconColor)
					})
					.offset(x: -.spacing(.big), y: .spacing(.none))
				}
			}
			statusView(status: status)
		}
	}
	
	@ViewBuilder private func statusView(status: TextEditStatus) -> some View {
		switch status {
		case let .error(value):
			Text(value)
				.font(.callout)
				.foregroundColor(.red)
		case let .success(value):
			Text(value)
				.font(.callout)
				.foregroundColor(.green)
		case .default:
			EmptyView()
		}
	}
}

struct ToggableTextEditingView_Previews: PreviewProvider {
    static var previews: some View {
		ClearTextEditingView(placholder: "Text",
							 text: .constant(""),
							 status: .success("Incorrect e-mail"))
    }
}
