//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources

struct SettingsScene: View {
    
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        ScrollView {
            WithViewStore(store) { viewStore in
                Button {
                    viewStore.send(.logoutPressed)
                } label: {
                    Text(Localizable.logoutButtonTitle)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .bubbled()
                .padding()
            }
        }
        .navigationTitle(Localizable.settings)
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}
