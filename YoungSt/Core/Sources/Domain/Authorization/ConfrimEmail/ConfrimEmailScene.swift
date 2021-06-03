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
		ZStack(alignment: .center) {
			WithViewStore(store.scope(state: \.isLoading)) { viewStore in
				if viewStore.state {
					IndicatorView()
				}
			}
			VStack {
				Spacer()
				HeaderDescriptionView(title: Constants.Text.verification,
									  subtitle: Constants.Text.emailSendedToConfrim)
				WithViewStore(store) { viewStore in
					ClearTextEditingView(placholder: Localizable.enterCode,
										 text: viewStore.binding(get: \.code, send: ConfrimEmailAction.didCodeStartEnter),
										 status: .default)
						.padding(.top, .spacing(.extraSize))
						.padding(.horizontal, .spacing(.extraSize))
				}
				Spacer()
				WithViewStore(store.stateless) { viewStore in
					Button(action: { viewStore.send(.didConfrimButtonTapped) }, label: {
						Text(Constants.Text.verify)
					})
					.buttonStyle(RoundedButtonStyle(style: .filled))
					.padding(.bottom, .spacing(.extraSize))
				}
				Spacer()
			}
			.alert(store.scope(state: \.alert), dismiss: ConfrimEmailAction.alertOkButtonTapped)
		}
	}
}

struct ConfrimCodeView_Previews: PreviewProvider {
    static var previews: some View {
		ConfrimEmailScene(store: .init(initialState: .init(userId: UUID(uuidString: "123")!, credentails: .init(email: "", passsword: "")), reducer: .empty, environment: ()))
    }
}
