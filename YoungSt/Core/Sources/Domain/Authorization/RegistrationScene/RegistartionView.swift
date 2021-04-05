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
        static let nicknamePlaceholder = Localizable.nicknamePlaceholder
        static let passwordPlaceholder = Localizable.passwordPlaceholder
    }
}

struct RegistrationView: View {
    let store: Store<RegistrationState, RegistrationAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            TextEditingView1.init(placholder: Constants.emailPlaceholder, text: viewStore.binding(get: \.email, send: RegistrationAction.didEmailChanged))
        }
    }
}

struct TextEditingView1: View {
    let placholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placholder, text: $text)
            .padding()
            .bubble(color: Color.gray, lineWidth: 1)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: registrationReducer, environment: RegistrationEnviroment(authorizationService: nil)))
    }
}
