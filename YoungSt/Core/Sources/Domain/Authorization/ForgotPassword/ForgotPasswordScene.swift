//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 02.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct ForgotPasswordScene: View {
    
	let store: Store<ForgotPasswordState, ForgotPasswordAction>
    
    init(store: Store<ForgotPasswordState, ForgotPasswordAction>) {
        self.store = store
    }
    
	@State private var contentOffset: CGFloat = 0
	@State private var dividerHidden: Bool = true
	private var requiredOffset: CGFloat = 0
	
	var body: some View {
		GeometryReader { globalProxy in
			ZStack {
				TrackableScrollView(contentOffset: $contentOffset) {
					VStack {
						HeaderDescriptionView(title: Localizable.forgotPasswordTitle, subtitle: Localizable.forgotPasswordSubtitle)
						
						WithViewStore(store) { viewStore in
                            AuthTextInput(text: viewStore.binding(get: \.email.value, send: ForgotPasswordAction.didEmailEditing),
                                          forceFocused: viewStore.binding(get: \.emailFieldForceFocused, send: ForgotPasswordAction.emailInputFocusChanged),
                                          status: .constant(.default),
                                          placeholder: Localizable.emailPlaceholder)
                            
							if viewStore.isResetPasswordInit {
                                AuthTextInput(text: viewStore.binding(get: \.code.value, send: ForgotPasswordAction.didCodeEditing),
                                              forceFocused: viewStore.binding(get: \.codeFieldForceFocused, send: ForgotPasswordAction.confirmPasswordInputFocusChanged),
                                              status: .constant(.default),
                                              placeholder: Localizable.enterCode)
                                
                                AuthSecureInput(text: viewStore.binding(get: \.password.value, send: ForgotPasswordAction.didPasswordEditing),
                                                forceFocused: viewStore.binding(get: \.passwordFieldForceFocused, send: ForgotPasswordAction.passwordInputFocusChanged),
                                                status: .constant(.default),
                                                isSecure: viewStore.binding(get: \.isPasswordShowed, send: ForgotPasswordAction.passwordButtonTapped),
                                                placeholder: Localizable.passwordPlaceholder)
                                
                                AuthSecureInput(text: viewStore.binding(get: \.confrimPassword.value, send: ForgotPasswordAction.didConrimPasswordEditing),
                                                forceFocused: viewStore.binding(get: \.confirmPasswordFieldForceFocused, send: ForgotPasswordAction.confirmPasswordInputFocusChanged),
                                                status: .constant(.default),
                                                isSecure: viewStore.binding(get: \.isConfrimPasswordShowed, send: ForgotPasswordAction.confrimPasswordButtonTapped),
                                                placeholder: Localizable.confrimPasswordPlaceholder)
							}
						}
						.padding(.top)
					}
					.padding(.horizontal)
					.padding(.top, .spacing(.header))
				}
				
				WithViewStore(store) { viewStore in
					VStack {
						Button(Localizable.sendCode, action: { viewStore.send(.didSendCodeButtonTapped) })
							.buttonStyle(RoundedButtonStyle(style: .empty))
							.alert(store.scope(state: \.alert), dismiss: ForgotPasswordAction.alertOkButtonTapped)
						Button(Localizable.resetPassword, action: { viewStore.send(.didChangePasswordButtonTapped) })
							.buttonStyle(RoundedButtonStyle(style: .filled))
							.foregroundColor(viewStore.isResetPasswordInit ? Color.white.opacity(0.4) : Asset.Colors.greenDark.color.swiftuiColor)
							.disabled(!viewStore.isResetPasswordInit)
							.alert(store.scope(state: \.alert), dismiss: ForgotPasswordAction.alertOkButtonTapped)
					}
					.greedy(aligningContentTo: .bottom)
					.ignoresSafeArea(.keyboard, edges: .bottom)
				}
			}
			.overlay(
				TopHeaderView(width: globalProxy.size.width,
							  topSafeAreaInset: globalProxy.safeAreaInsets.top)
					.opacity(dividerHidden ? 0 : 1)
			)
		}
		.makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden, requiredOffset: .spacing(.header))
	}
}

struct ForgotPasswordScene_Previews: PreviewProvider {
    static var previews: some View {
		ForgotPasswordScene(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
