//
//  File.swift
//  
//
//  Created by Nikita Patskov on 24.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct FinishProfileUpdatingScene: View {
    
    let store: Store<EditProfileState, EditProfileAction>
    
    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            ZStack {
                ScrollView {
                    VStack(spacing: .spacing(.ultraBig)) {
                        VStack {
                            Text(Localizable.fillInfoWelcome)
                                .font(.title)
                            Text(Localizable.fillInfoDescription)
                                .foregroundColor(.secondary)
                                .font(.body)
                        }
                        .multilineTextAlignment(.center)
                        
                        EditProfileFielsView(store: store)
                            .padding(.bottom, RoundedButtonStyle.minHeight)
                            .padding(.bottom)
                    }
                    .padding(.top)
                }
                .introspectScrollView { $0.keyboardDismissMode = .interactive }
                
                WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                    Button { viewStore.send(.editProfileTriggered) } label: {
                        Text(Localizable.editProfileAction)
                    }
                    .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.state))
                }
                .padding(.bottom)
                .greedy(aligningContentTo: .bottom)
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationBarTitleDisplayMode(.inline)
    }
}
