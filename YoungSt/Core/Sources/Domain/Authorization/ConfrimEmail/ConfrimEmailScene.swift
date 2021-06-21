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

struct ConfrimEmailScene: View {
	let store: Store<ConfrimEmailState, ConfrimEmailAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				Spacer()
				HeaderDescriptionView(title: Constants.Text.verification,
									  subtitle: Constants.Text.emailSendedToConfrim)
                    AuthTextInput(text: viewStore.binding(get: \.code, send: ConfrimEmailAction.didCodeStartEnter),
                                  forceFocused: viewStore.binding(get: \.codeFieldForceFocused, send: ConfrimEmailAction.codeInputFocusChanged),
                                  status: .constant(.default),
                                  placeholder: Localizable.enterCode)
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
			.alert(store.scope(state: \.alert), dismiss: ConfrimEmailAction.alertOkButtonTapped)
		}
	}
}

struct ConfrimCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ConfrimEmailScene(store: .init(initialState: .init(userId: UUID(), email: "", passsword: ""), reducer: .empty, environment: ()))
    }
}
