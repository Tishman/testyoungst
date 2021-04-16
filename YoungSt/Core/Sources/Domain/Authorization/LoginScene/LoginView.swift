//
//  LoginView.swift
//  YoungSt
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

extension LoginView {
    enum Constants {
        static let emailPlaceholder = Localizable.emailPlaceholder
        static let passwordPlaceholder = Localizable.passwordPlaceholder
        static let welcomeBackTitle = Localizable.welcomeBackTitle
        static let loginToReturnTitle = Localizable.loginToReturnTitle
        static let loginButtonTitle = Localizable.loginButtonTitle
        static let registrationButtonTitle = Localizable.registrationButtonTitle
		static let incorrectData = Localizable.incorrectDataTitle
		static let ok = Localizable.ok
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HeaderDescriptionView(title: Constants.welcomeBackTitle, subtitle: Constants.loginToReturnTitle)
                    .padding(.top, .spacing(.big))
                
                VStack(spacing: .spacing(.ultraBig)) {
                    TextEditingView(placholder: Constants.emailPlaceholder,
                                    text: viewStore.binding(get: \.email, send: LoginAction.emailChanged))
                    
                    ToggableSecureField(placholder: Constants.passwordPlaceholder,
                                        text: viewStore.binding(get: \.password, send: LoginAction.passwordChanged),
                                        showPassword: viewStore.showPassword,
                                        clouser: { viewStore.send(.showPasswordButtonTapped) })
                }
                .padding(.horizontal, .spacing(.ultraBig))
                .padding(.top, .spacing(.extraSize))
                
                Spacer()
                
                Button(action: { viewStore.send(.loginTapped) }, label: {
                    Text(Constants.loginButtonTitle)
                })
                .buttonStyle(RoundedButtonStyle(style: .filled))
                .padding(.bottom, .spacing(.ultraBig))
            }
			.alert(isPresented: viewStore.binding(get: \.isAlerPresent, send: LoginAction.alertPresented), content: {
				Alert(title: Text(Constants.incorrectData), message: Text(viewStore.alertMessage), dismissButton: .default(Text(Constants.ok)))
			})
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
