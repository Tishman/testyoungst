//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import SwiftUI
import Resources
import Utilities
import ComposableArchitecture

extension WelcomeView {
	enum Constants {
		static let welcomeTitle = Localizable.welcomeTitle
		static let loginOrCreateAccountSubtitle = Localizable.loginOrRegisterAccountSubtitle
		static let login = Localizable.loginButtonTitle
		static let registration = Localizable.registrationButtonTitle
	}
}

struct WelcomeView: View {
	let store: Store<WelcomeState, WelcomeAction>
	
	var body: some View {
		WithViewStore(store) { viewStore in
			NavigationView {
				VStack {
					HeaderDescriptionView(title: Constants.welcomeTitle,
										  subtitle: Constants.loginOrCreateAccountSubtitle)
						.padding(.top, .spacing(.big))
					Spacer()
					
					Image(uiImage: Asset.Images.welcome.image)
					
					Spacer()
					
					VStack(spacing: .spacing(.big)) {
							Button(action: {}, label: {
								NavigationLink(destination: LoginView(store: self.store.scope(state: \.loginState, action: WelcomeAction.login(action:)))) {
									Text(Constants.login)
								}
							})
							.buttonStyle(RoundedButtonStyle(style: .filled))
						}
					
					Button(action: {}, label: {
						NavigationLink(
							destination: RegistrationView(store: self.store.scope(state: \.registrationState, action: WelcomeAction.registration(action:))),
							label: {
								Text(Constants.registration)
							})
					})
					.buttonStyle(RoundedButtonStyle(style: .empty))
					.padding(.bottom, .spacing(.ultraBig))
				}
				.navigationBarTitle(Constants.welcomeTitle, displayMode: .inline)
			}
			.navigationBarTitle(Constants.welcomeTitle, displayMode: .inline)
		}
	}
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
		WelcomeView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
