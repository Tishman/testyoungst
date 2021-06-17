//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources

struct SettingsView: View {
    
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button {
                viewStore.send(.logoutPressed)
            } label: {
                Text(Localizable.logoutButtonTitle)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .bubbled()
            .padding()
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}
