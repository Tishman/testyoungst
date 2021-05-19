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
							ClearTextEditingView(placholder: Localizable.emailPlaceholder,
												 text: viewStore.binding(get: \.email.value, send: ForgotPasswordAction.didEmailEditing),
												 status: viewStore.email.status)
							if viewStore.isResetPasswordInit {
								ClearTextEditingView(placholder: Localizable.enterCode,
													 text: viewStore.binding(get: \.code.value, send: ForgotPasswordAction.didCodeEditing),
													 status: viewStore.code.status)
								ToggableSecureField(placholder: Localizable.passwordPlaceholder,
													text: viewStore.binding(get: \.password.value, send: ForgotPasswordAction.didPasswordEditing),
													status: viewStore.password.status,
													isPasswordHidden: viewStore.isPasswordHidden,
													clouser: { viewStore.send(.passwordButtonTapped) })
								ToggableSecureField(placholder: Localizable.confrimPasswordPlaceholder,
													text: viewStore.binding(get: \.confrimPassword.value, send: ForgotPasswordAction.didConrimPasswordEditing),
													status: viewStore.confrimPassword.status,
													isPasswordHidden: viewStore.isConfrimPasswordHidden,
													clouser: { viewStore.send(.confrimPasswordButtonTapped) })
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
							.buttonStyle(RoundedButtonStyle(style: .filled, isDisabled: !viewStore.isResetPasswordInit))
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
