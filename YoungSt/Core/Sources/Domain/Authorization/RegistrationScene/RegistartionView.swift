//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

extension RegistrationView {
    enum Constants {
        static let emailPlaceholder = Localizable.emailPlaceholder
        static let usernamePlaceholder = Localizable.usernamePlaceholder
        static let passwordPlaceholder = Localizable.passwordPlaceholder
        static let confrimPasswordPlaceholder = Localizable.confrimPasswordPlaceholder
        static let registrationButtonTitle = Localizable.registrationButtonTitle
        static let welcomeTitle = Localizable.welcomeTitle
        static let registerToStartTitle = Localizable.registerToStartTitle
        static let closeTitle = Localizable.closeTitle
		static let incorrectData = Localizable.incorrectDataTitle
		static let ok = Localizable.ok
    }
}

struct RegistrationView: View {
    let store: Store<RegistrationState, RegistrationAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HeaderDescriptionView(title: Constants.welcomeTitle, subtitle: Constants.registerToStartTitle)
                .padding(.top, .spacing(.big))
                
                VStack(spacing: .spacing(.big)) {
					ToggableTextEditingView(placholder: Constants.emailPlaceholder,
											text: viewStore.binding(get: \.email, send: RegistrationAction.didEmailChanged))
					ToggableTextEditingView(placholder: Constants.usernamePlaceholder,
											text: viewStore.binding(get: \.nickname, send: RegistrationAction.didNicknameChange))
					ToggableSecureField(placholder: Constants.passwordPlaceholder,
										text: viewStore.binding(get: \.password, send: RegistrationAction.didPasswordChanged),
										showPassword: viewStore.isPasswordShowed,
										clouser: { viewStore.send(.showPasswordButtonTapped(.password)) })
					ToggableSecureField(placholder: Constants.confrimPasswordPlaceholder,
										text: viewStore.binding(get: \.confrimPassword, send: RegistrationAction.didConfrimPasswordChanged),
										showPassword: viewStore.isConfrimPasswordShowed,
										clouser: { viewStore.send(.showPasswordButtonTapped(.confrimPassword)) })
                }
                .padding(.horizontal, .spacing(.ultraBig))
                .padding(.top, .spacing(.extraSize))
                
                Spacer()
				
                VStack {
					Button(action: { viewStore.send(.registrationButtonTapped) }, label: {
						Text(Constants.registrationButtonTitle)
					})
                    .buttonStyle(RoundedButtonStyle(style: .filled))
					.navigate(using: viewStore.binding(get: \.isCodeConfrimed, send: RegistrationAction.confrimCodeOpenned),
							  destination: IfLetStore(store.scope(state: \.confrimCodeState, action: RegistrationAction.confrimCode),
													  then: ConfrimCodeView.init(store:)))
                }
                .padding(.bottom, .spacing(.ultraBig))
            }
			.alert(isPresented: viewStore.binding(get: \.isAlertPresent, send: RegistrationAction.alertPresented), content: {
				Alert(title: Text(Constants.incorrectData), message: Text(viewStore.alertMessage), dismissButton: .default(Text(Constants.ok)))
			})
			.navigationBarTitle("Registration", displayMode: .inline)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: registrationReducer, environment: RegistrationEnviroment(authorizationService: nil)))
    }
}
