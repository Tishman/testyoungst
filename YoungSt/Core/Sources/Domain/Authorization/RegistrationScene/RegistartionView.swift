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
    }
}

struct RegistrationView: View {
    let store: Store<RegistrationState, RegistrationAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                WelcomeView(title: Constants.welcomeTitle, subtitle: Constants.registerToStartTitle)
                .padding(.top, .spacing(.big))
                
                VStack(spacing: 20) {
                    TextEditingView.init(placholder: Constants.emailPlaceholder,
                                         color: Asset.Colors.greenLightly.color.swiftuiColor,
                                         showPassword: true,
                                          text: viewStore.binding(get: \.email, send: RegistrationAction.didEmailChanged))
                    TextEditingView.init(placholder: Constants.usernamePlaceholder,
                                         color: Asset.Colors.greenLightly.color.swiftuiColor,
                                         showPassword: true,
                                         text: viewStore.binding(get: \.nickname, send: RegistrationAction.didNicknameChange))
                    TextEditingView.init(placholder: Constants.passwordPlaceholder,
                                         color: Asset.Colors.greenLightly.color.swiftuiColor,
                                         showPassword: true,
                                         text: viewStore.binding(get: \.password, send: RegistrationAction.didPasswordChanged))
                    TextEditingView(placholder: Constants.confrimPasswordPlaceholder,
                                    color: Asset.Colors.greenLightly.color.swiftuiColor,
                                    showPassword: true,
                                    text: viewStore.binding(get: \.confrimPassword, send: RegistrationAction.didConfrimPasswordChanged))
                }
                .padding(.horizontal, .spacing(.ultraBig))
                .padding(.top, .spacing(.extraSize))
                Spacer()
                
                Button(action: { viewStore.send(.registrationButtonTapped) }, label: {
                    Text(Constants.registrationButtonTitle)
                        .padding()
                        .foregroundColor(.white)
                        .background(Asset.Colors.greenDark.color.swiftuiColor)
                        .cornerRadius(8)
                })
                .padding(.bottom, .spacing(.ultraBig))
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: registrationReducer, environment: RegistrationEnviroment(authorizationService: nil)))
    }
}
