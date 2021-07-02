//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 14.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct EditProfileScene: View {
    
    let store: Store<EditProfileState, EditProfileAction>
    
    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            ZStack {
                ScrollView {
                    VStack(spacing: .spacing(.ultraBig)) {
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
        .alert(store.scope(state: \.alert), dismiss: .alertClosedTriggered)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileFielsView: View {
    
    let store: Store<EditProfileState, EditProfileAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                WithViewStore(store.scope(state: \.firstName)) { viewStore in
                    TextField(Localizable.firstName, text: viewStore.binding(send: EditProfileAction.firstNameChanged))
                }
                .padding()
                .bubbled()
                
                IfLetStore(store.scope(state: \.firstNameError)) { store in
                    WithViewStore(store) { viewStore in
                        Text(viewStore.state)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                WithViewStore(store.scope(state: \.lastName)) { viewStore in
                    TextField(Localizable.lastName, text: viewStore.binding(send: EditProfileAction.lastNameChanged))
                }
                .padding()
                .bubbled()
                
                WithViewStore(store.scope(state: \.nickname)) { viewStore in
                    TextField(Localizable.nickname, text: viewStore.binding(send: EditProfileAction.nicknameChanged))
                }
                .padding()
                .bubbled()
                
                IfLetStore(store.scope(state: \.nicknameError)) { store in
                    WithViewStore(store) { viewStore in
                        Text(viewStore.state)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
    }
}

struct FinishProfileUpdatingScene_Previews: PreviewProvider {
    static var previews: some View {
        FinishProfileUpdatingScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
