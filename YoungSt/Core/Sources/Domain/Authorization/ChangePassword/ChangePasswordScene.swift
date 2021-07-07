//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 01.07.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct ChangePasswordScene: View {
    let store: Store<ChangePasswordState, ChangePasswordAction>
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack {
                        HeaderDescriptionView(title: Localizable.newPassword,
                                              subtitle: Localizable.createNewPasswordForLogin)
                            .padding(.top, .spacing(.big))
                        
                        WithViewStore(store) { viewStore in
                            VStack(spacing: .spacing(.ultraBig)) {
                                AuthSecureInput(text: viewStore.binding(get: \.password, send: ChangePasswordAction.passswordUpdated),
                                                forceFocused: viewStore.binding(get: \.passwordFieldForceFocused, send: ChangePasswordAction.passwordInputFocusChanged),
                                                isSecure: viewStore.binding(get: \.isPasswordSecure, send: ChangePasswordAction.showPasswordButtonTapped),
                                                status: .default,
                                                placeholder: Localizable.newPassword,
                                                returnKey: { viewStore.send(.passwordReturnKeyTriggered) })
                                
                                AuthSecureInput(text: viewStore.binding(get: \.confirmPassword, send: ChangePasswordAction.confirmPasswordUpdated),
                                                forceFocused: viewStore.binding(get: \.confirmPasswordFieldForceFocused, send: ChangePasswordAction.confirmPasswordInputFocusChanged),
                                                isSecure: viewStore.binding(get: \.isConfirmPasswordSecure, send: ChangePasswordAction.showConfirmPasswordButtonTapped),
                                                status: .default,
                                                placeholder: Localizable.confrimPasswordPlaceholder,
                                                returnKey: { viewStore.send(.confirmPasswordReturnKeyTriggered ) })
                            }
                        }
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
                    }
                }
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
                .frame(maxWidth: WelcomeView.maxWidth)
                
                WithViewStore(store) { viewStore in
                    Button(action: { viewStore.send(.changePasswordButtonTapped) }, label: {
                        Text(Localizable.verify)
                    })
                    .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.isLoading))
                }
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
        .alert(store.scope(state: \.alert), dismiss: ChangePasswordAction.alertOkButtonTapped)
    }
}

struct ChangePasswordScene_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordScene(store: .init(initialState: .init(email: "", code: ""), reducer: .empty, environment: ()))
    }
}
