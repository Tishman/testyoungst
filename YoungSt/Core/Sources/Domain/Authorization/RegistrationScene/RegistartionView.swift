//
//  SwiftUIView.swift
//  
//
//  Created by Роман Тищенко on 03.04.2021.
//

import SwiftUI
import ComposableArchitecture
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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
