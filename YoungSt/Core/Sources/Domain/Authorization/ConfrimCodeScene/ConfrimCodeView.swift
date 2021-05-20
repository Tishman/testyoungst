//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 17.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

enum Constants {
	enum Colors {
		static let greenDark = Asset.Colors.greenDark.color.swiftuiColor
	}
	
	enum Text {
		static let verification = Localizable.verification
		static let verify = Localizable.verify
		static let emailSendedToConfrim = Localizable.emailSendedToConfrim
		static let enterCode = Localizable.enterCode
		static let incorrectData = Localizable.incorrectDataTitle
		static let ok = Localizable.ok
	}
}

struct ConfrimCodeView: View {
	let store: Store<ConfrimCodeState, ConfrimCodeAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				Spacer()
				HeaderDescriptionView(title: Constants.Text.verification,
									  subtitle: Constants.Text.emailSendedToConfrim)
				ToggableTextEditingView(placholder: Localizable.enterCode,
										text: viewStore.binding(get: \.code, send: ConfrimCodeAction.didCodeStartEnter))
					.padding(.top, .spacing(.extraSize))
					.padding(.horizontal, .spacing(.extraSize))
				Spacer()
				Button(action: { viewStore.send(.didConfrimButtonTapped) }, label: {
					Text(Constants.Text.verify)
				})
                .buttonStyle(RoundedButtonStyle(style: .filled))
				.padding(.bottom, .spacing(.extraSize))
				Spacer()
			}
			.alert(isPresented: viewStore.binding(get: \.isAlertPresent, send: ConfrimCodeAction.alertPresented), content: {
				Alert(title: Text(Constants.Text.incorrectData), message: Text(viewStore.alertMessage), dismissButton: .default(Text(Constants.Text.ok)))
			})
		}
	}
}

struct ConfrimCodeView_Previews: PreviewProvider {
    static var previews: some View {
		ConfrimCodeView(store: .init(initialState: .init(userId: "123"), reducer: .empty, environment: ()))
    }
}
