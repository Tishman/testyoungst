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
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack {
                        HeaderDescriptionView(title: Constants.welcomeTitle, subtitle: Constants.registerToStartTitle)
                            .padding(.top, .spacing(.big))
                        
                        WithViewStore(store) { viewStore in
                            VStack(spacing: .spacing(.big)) {
                                AuthTextInput(text: viewStore.binding(get: \.email, send: RegistrationAction.didEmailChanged),
                                              forceFocused: viewStore.binding(get: \.emailFieldForceFocused, send: RegistrationAction.emailInputFocusChanged),
                                              status: .constant(.default), placeholder: Localizable.emailPlaceholder)
                                
                                AuthTextInput(text: viewStore.binding(get: \.nickname, send: RegistrationAction.didNicknameChange),
                                              forceFocused: viewStore.binding(get: \.usernameFieldForceFocused, send: RegistrationAction.userNameInputFocusChanged),
                                              status: .constant(.default),
                                              placeholder: Localizable.usernamePlaceholder)
                                
                                AuthSecureInput(text: viewStore.binding(get: \.password, send: RegistrationAction.didPasswordChanged),
                                                forceFocused: viewStore.binding(get: \.passwordFieldForceFocused, send: RegistrationAction.passwordInputFocusChanged),
                                                status: .constant(.default),
                                                isSecure: viewStore.binding(get: \.isPasswordSecure, send: RegistrationAction.showPasswordButtonTapped),
                                                placeholder: Localizable.passwordPlaceholder)
                                
                                AuthSecureInput(text: viewStore.binding(get: \.confrimPassword, send: RegistrationAction.didConfrimPasswordChanged),
                                                forceFocused: viewStore.binding(get: \.confirmPasswordFieldForceFocused, send: RegistrationAction.confirmPasswordInputFocusChanged),
                                                status: .constant(.default),
                                                isSecure: viewStore.binding(get: \.isConfirmSecure, send: RegistrationAction.showConfrimPasswordButtonTapped),
                                                placeholder: Localizable.confrimPasswordPlaceholder)
                            }
                        }
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
                    }
                }
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
                
                WithViewStore(store) { viewStore in
                    Button(action: { viewStore.send(.registrationButtonTapped) }, label: {
                        Text(Constants.registrationButtonTitle)
                    })
                    .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.isLoading))
                    .padding(.bottom)
                    .greedy(aligningContentTo: .bottom)
                }
            }
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
            .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
