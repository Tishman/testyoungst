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

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack {
                        HeaderDescriptionView(title: Localizable.welcomeBackTitle, subtitle: Localizable.loginToReturnTitle)
                            .padding(.top, .spacing(.big))
                        
                        WithViewStore(store) { viewStore in
                            VStack(spacing: .spacing(.ultraBig)) {
                                AuthTextInput(text: viewStore.binding(get: \.email, send: LoginAction.emailChanged),
                                              forceFocused: viewStore.binding(get: \.loginFieldForceFocused, send: LoginAction.loginInputFocusChanged),
                                              isSecureMode: .constant(false),
                                              isClearMode: true,
                                              placeholder: Localizable.emailPlaceholder,
                                              status: .default,
                                              delegate: nil)
                                
                                AuthTextInput(text: viewStore.binding(get: \.password, send: LoginAction.passwordChanged),
                                              forceFocused: viewStore.binding(get: \.passwordFieldForceFocused, send: LoginAction.passwordInputFocusChanged),
                                              isSecureMode: viewStore.binding(get: \.isSecure, send: LoginAction.showPasswordButtonTapped),
                                              isClearMode: false,
                                              placeholder: Localizable.passwordPlaceholder,
                                              status: .default,
                                              delegate: nil)
								Button(action: { viewStore.send(.forgotPasswordTapped) }, label: {
									Text(Localizable.forgotPasswordTitle)
										.font(.callout)
										.foregroundColor(Asset.Colors.grayLight.color.swiftuiColor)
								})
                            }
                        }
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
                    }
                }
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
                
                WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                    if viewStore.state {
                        IndicatorView()
                    }
                }
                
                WithViewStore(store.stateless) { viewStore in
                    Button(action: { viewStore.send(.loginTapped) }, label: {
                        Text(Localizable.loginButtonTitle)
                    })
                }
                .buttonStyle(RoundedButtonStyle(style: .filled))
                .padding(.bottom)
                .greedy(aligningContentTo: .bottom)
            }
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
        }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .alert(store.scope(state: \.alertState), dismiss: .alertClosed)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
