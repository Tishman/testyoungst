//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 10.04.2021.
//

import SwiftUI
import Resources
import Utilities
import ComposableArchitecture

extension WelcomeView {
    enum Constants {
        static let welcomeTitle = Localizable.welcomeTitle
        static let loginOrCreateAccountSubtitle = Localizable.loginOrRegisterAccountSubtitle
        static let login = Localizable.loginButtonTitle
        static let registration = Localizable.registrationButtonTitle
    }
}

struct WelcomeView: View {
    let store: Store<WelcomeState, WelcomeAction>
    static let maxWidth = UIFloat(550)
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HeaderDescriptionView(title: Constants.welcomeTitle,
                                      subtitle: Constants.loginOrCreateAccountSubtitle)
                    .padding(.top, .spacing(.big))
                Spacer()
                
                Image(uiImage: Asset.Images.welcome.image)
                
                Spacer()
                
                VStack(spacing: .spacing(.big)) {
                    WithViewStore(store.stateless) { viewStore in
                        Button(action: { viewStore.send(.route(.login)) }, label: {
                            Text(Constants.login)
                        })
                    }
                    .buttonStyle(RoundedButtonStyle(style: .filled))
                    
                    WithViewStore(store.stateless) { viewStore in
                        Button(action: { viewStore.send(.route(.registration)) }, label: {
                            Text(Constants.registration)
                        })
                    }
                    .buttonStyle(RoundedButtonStyle(style: .empty))
                    .padding(.bottom, .spacing(.ultraBig))
                }
            }
            .frame(maxWidth: Self.maxWidth)
        }
        .navigationBarTitleDisplayMode(.inline)
        .makeDefaultNavigationBarTransparent()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
