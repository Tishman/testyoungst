//
//  LoginView.swift
//  YoungSt
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            
            VStack {
                TextEditingView(title: viewStore.emailPlaceholder,
                                text: viewStore.binding(send: <#T##(LoginState) -> LoginAction#>))
                TextEditingView(store: store, get: \.email, send: LoginAction.didEmailChanged)
                TextField(viewStore.emailPlaceholder,
                          text: viewStore.binding(get: \.email, send: LoginAction.didEmailChanged))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                TextField(viewStore.passwordPlaceholder,
                          text: viewStore.binding(get: \.password, send: LoginAction.didPasswordChanged))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .lineSpacing(24)
            .padding(.horizontal, 12)
            
        }
    }
}

struct TextEditingView: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: Store<LoginState, LoginAction>(initialState: .init(), reducer: loginReducer, environment: LoginEnviroment(client: nil)))
    }
}
