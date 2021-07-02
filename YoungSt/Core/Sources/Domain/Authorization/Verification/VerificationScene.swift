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

struct VerificationScene: View {
    let store: Store<VerificationState, VerificationAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                HeaderDescriptionView(title: Localizable.enterCode, subtitle: Localizable.codeEmailSended)
                
                CodeEnterView(store: store.scope(state: \.codeEnter, action: VerificationAction.codeEnter))
                
                Button(action: { viewStore.send(.sendCodeButtonTapped) }, label: {
                    Text(Localizable.verify)
                })
                .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.isLoading))
                .padding(.bottom, .spacing(.extraSize))
                Spacer()
            }
            .onAppear {
                viewStore.send(.viewDidAppear)
            }
        }
        .alert(store.scope(state: \.alert), dismiss: VerificationAction.alertOkButtonTapped)
    }
}

struct VerificationScene_Previews: PreviewProvider {
    static var previews: some View {
        VerificationScene(store: .init(initialState: .init(email: ""), reducer: .empty, environment: ()))
    }
}
