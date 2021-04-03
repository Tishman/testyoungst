//
//  LoginView.swift
//  YoungSt
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources

extension LoginView {
    enum Constants {
        static let emailPlaceholder = Localizable.emailPlaceholder
        static let passwordPlaceholder = Localizable.passwordPlaceholder
    }
}

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextEditingView(placholder: Constants.emailPlaceholder,
                                text: viewStore.binding(get: \.email, send: LoginAction.emailChanged))
                
                TextEditingView(placholder: Constants.passwordPlaceholder,
                                text: viewStore.binding(get: \.password, send: LoginAction.passwordChanged))
            }
            .lineSpacing(.spacing(.ultraBig))
            .padding(.horizontal, .spacing(.medium))
        }
    }
}

struct TextEditingView: View {
    let placholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: .corner(.big), style: .continuous)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
