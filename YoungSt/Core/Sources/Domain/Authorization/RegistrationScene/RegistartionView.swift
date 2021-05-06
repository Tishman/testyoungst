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
                                ClearTextEditingView(placholder: Constants.emailPlaceholder,
													 text: viewStore.binding(get: \.email, send: RegistrationAction.didEmailChanged),
													 status: .success("sas"))
                                
                                ClearTextEditingView(placholder: Constants.usernamePlaceholder,
													 text: viewStore.binding(get: \.nickname, send: RegistrationAction.didNicknameChange),
													 status: .default)
                                
                                ToggableSecureField(placholder: Constants.passwordPlaceholder,
													text: viewStore.binding(get: \.password, send: RegistrationAction.didPasswordChanged),
													status: .success("ads"),
                                                    showPassword: viewStore.isPasswordShowed,
                                                    clouser: { viewStore.send(.showPasswordButtonTapped(.password)) })
                                
                                ToggableSecureField(placholder: Constants.confrimPasswordPlaceholder,
													text: viewStore.binding(get: \.confrimPassword, send: RegistrationAction.didConfrimPasswordChanged),
													status: .default,
                                                    showPassword: viewStore.isConfrimPasswordShowed,
                                                    clouser: { viewStore.send(.showPasswordButtonTapped(.confrimPassword)) })
                            }
                        }
                        .padding(.horizontal, .spacing(.ultraBig))
                        .padding(.top, .spacing(.extraSize))
                    }
                }
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
                
                WithViewStore(store.stateless) { viewStore in
                    Button(action: { viewStore.send(.registrationButtonTapped) }, label: {
                        Text(Constants.registrationButtonTitle)
                    })
                }
                .buttonStyle(RoundedButtonStyle(style: .filled))
                .padding(.bottom)
                .greedy(aligningContentTo: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
            .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .background(confirmCodeLink)
    }
    
    private var confirmCodeLink: some View {
        WithViewStore(store.scope(state: \.confrimCodeState)) { viewStore in
            NavigationLink.init(destination: IfLetStore(store.scope(state: \.confrimCodeState, action: RegistrationAction.confrimCode),
                                                        then: ConfrimEmailScene.init),
                                isActive: viewStore.binding(get: { $0 != nil }, send: RegistrationAction.confrimCodeClosed),
                                label: {})
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
