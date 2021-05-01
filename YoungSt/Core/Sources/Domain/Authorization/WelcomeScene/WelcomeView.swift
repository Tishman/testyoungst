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
						WithViewStore(store.stateless) { viewStore in
							Button(action: { viewStore.send(.loginOpenned(true)) }, label: {
								Text(Constants.login)
							})
						}
						.buttonStyle(RoundedButtonStyle(style: .filled))
						
						WithViewStore(store.stateless) { viewStore in
							Button(action: { viewStore.send(.registrationOppend(true)) }, label: {
								Text(Constants.registration)
							})
						}
						.buttonStyle(RoundedButtonStyle(style: .empty))
						.padding(.bottom, .spacing(.ultraBig))
					}
				}
				.background(
					WithViewStore(store.scope(state: \.registrationState)) { viewStore in
						NavigationLink(destination: IfLetStore(store.scope(state: \.registrationState, action: WelcomeAction.registration),
															   then: RegistrationView.init(store:)),
									   isActive: viewStore.binding(get: { $0 != nil }, send: WelcomeAction.registrationOppend),
									   label: {})
					}
				)
				.background(
					WithViewStore(store.scope(state: \.loginState)) { viewStore in
						NavigationLink(destination: IfLetStore(store.scope(state: \.loginState,
																		   action: WelcomeAction.login),
															   then: LoginView.init(store:)),
									   isActive: viewStore.binding(get: { $0 != nil }, send: WelcomeAction.loginOpenned),
									   label: {})
					}
				)
				.navigationBarTitle(Constants.welcomeTitle)
			}
		}
	}
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
		WelcomeView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
