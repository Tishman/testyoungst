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
                            .padding(.top, .spacing(.big))
                        
						WithViewStore(store) { viewStore in
                            AuthTextInput(text: viewStore.binding(get: \.email.value, send: ForgotPasswordAction.didEmailEditing),
                                          forceFocused: viewStore.binding(get: \.emailFieldForceFocused, send: ForgotPasswordAction.emailInputFocusChanged),
                                          status: .default,
                                          placeholder: Localizable.enterYourEmail)
						}
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
					}
				}
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
				
                WithViewStore(store) { viewStore in
                    Button(action: { viewStore.send(.didSendCodeButtonTapped) }, label: {
                        Text(Localizable.send)
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
		.makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden, requiredOffset: .spacing(.header))
        .alert(store.scope(state: \.alert), dismiss: ForgotPasswordAction.alertOkButtonTapped)
	}
}

struct ForgotPasswordScene_Previews: PreviewProvider {
    static var previews: some View {
		ForgotPasswordScene(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
