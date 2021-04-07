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
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                WelcomeView(title: Constants.welcomeBackTitle, subtitle: Constants.loginToReturnTitle)
                    .padding(.top, .spacing(.big))
                
                VStack(spacing: .spacing(.ultraBig)) {
                    TextEditingView(placholder: Constants.emailPlaceholder,
                                    color: Color(Asset.Colors.greenLightly.color),
                                    showPassword: true,
                                    text: viewStore.binding(get: \.email, send: LoginAction.emailChanged))
                    
                    ZStack(alignment: .trailing) {
                        TextEditingView(placholder: Constants.passwordPlaceholder,
                                        color: Color(Asset.Colors.greenLightly.color),
                                        showPassword: viewStore.showPassword,
                                    text: viewStore.binding(get: \.password, send: LoginAction.passwordChanged))
                        Button(action: { viewStore.send(.showPasswordButtonTapped) }, label: {
                            Image(uiImage: Asset.Images.eye.image)
                        })
                        .offset(x: -21, y: 0)
                    }
                }
                .padding(.horizontal, .spacing(.ultraBig))
                .padding(.top, .spacing(.extraSize))
                Spacer()
                
                VStack {
                    Button(action: { viewStore.send(.loginTapped) }, label: {
                        Text(Constants.loginButtonTitle)
                            .padding()
                            .foregroundColor(.white)
                            .background(Asset.Colors.greenDark.color.swiftuiColor)
                            .cornerRadius(.corner(.small))
                    })
                    
                    Button(action: { viewStore.send(.registerButtonTapped) }, label: {
                        Text(Constants.registrationButtonTitle)
                            .padding()
                            .foregroundColor(.white)
                            .background(Asset.Colors.greenDark.color.swiftuiColor)
                            .cornerRadius(.corner(.small))
                    })
                }
                .padding(.bottom, .spacing(.ultraBig))
            }
        }
    }
}

struct TextEditingView: View {
    let placholder: String
    let color: Color
    let showPassword: Bool
    @Binding var text: String
    
    var body: some View {
        if showPassword {
            TextField(placholder, text: $text)
                .padding()
                .bubble(color: color, lineWidth: 1)
                .cornerRadius(.corner(.big))
        } else {
            SecureField(placholder, text: $text)
                .padding()
                .bubble(color: color, lineWidth: 1)
                .cornerRadius(.corner(.big))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
