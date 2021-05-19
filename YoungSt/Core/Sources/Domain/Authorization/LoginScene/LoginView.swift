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
		static let forgotPassword = Localizable.forgotPasswordTitle
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack {
                        HeaderDescriptionView(title: Constants.welcomeBackTitle, subtitle: Constants.loginToReturnTitle)
                            .padding(.top, .spacing(.big))
                        
                        WithViewStore(store) { viewStore in
                            VStack(spacing: .spacing(.ultraBig)) {
                                TextEditingView(placholder: Constants.emailPlaceholder,
												text: viewStore.binding(get: \.email, send: LoginAction.emailChanged),
												status: .default)
                                
                                ToggableSecureField(placholder: Constants.passwordPlaceholder,
													text: viewStore.binding(get: \.password, send: LoginAction.passwordChanged),
													status: .default,
													isPasswordHidden: viewStore.showPassword,
                                                    clouser: { viewStore.send(.showPasswordButtonTapped) })
								Button(action: { viewStore.send(.forgotPasswordOpened(true)) }, label: {
									Text(Constants.forgotPassword)
										.font(.callout)
										.foregroundColor(Asset.Colors.grayLight.color.swiftuiColor)
								})
                            }
                        }
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
						.background(forgotPasswordLink)
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
                        Text(Constants.loginButtonTitle)
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
	
	private var forgotPasswordLink: some View {
		WithViewStore(store.scope(state: \.forgotPasswordState)) { viewStore in
			NavigationLink(
				destination: IfLetStore(store.scope(state: \.forgotPasswordState, action: LoginAction.forgotPassword), then: ForgotPasswordScene.init(store:)),
				isActive: viewStore.binding(get: { $0 != nil }, send: LoginAction.forgotPasswordOpened),
				label: {})
		}
	}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
