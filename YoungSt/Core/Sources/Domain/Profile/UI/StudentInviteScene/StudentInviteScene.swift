//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct StudentInviteScene: View {
    
    let store: Store<StudentInviteState, StudentInviteAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                VStack(spacing: .spacing(.medium)) {
                    if let avatarSource = viewStore.avatarSource {
                        ProfileAvatarView(source: avatarSource, size: .big)
                    }
                    
                    VStack {
                        if !viewStore.title.isEmpty {
                            Text(viewStore.title)
                                .font(.title.bold())
                        }
                        if !viewStore.nickname.isEmpty && viewStore.nickname != viewStore.title {
                            Text(viewStore.nickname)
                                .foregroundColor(.secondary)
                        }
                        if !viewStore.subtitle.isEmpty {
                            Text(viewStore.subtitle)
                        }
                        if let error = viewStore.error {
                            Text(error)
                                .foregroundColor(.red)
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.top, .spacing(.custom(80)))
                
                Spacer()
                
                Button(action: { viewStore.send(.performAction) }, label: {
                    Text(viewStore.actionType == .requestInvite ? Localizable.becomeStudent : Localizable.closeTitle)
                })
                .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.isLoading))
                .padding(.bottom)
            }
            .onAppear { viewStore.send(.viewAppeared) }
            .makeDefaultNavigationBarTransparent()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CloseButton { viewStore.send(.closeScene) }
                }
            }
        }
    }
}

struct StudentInviteScene_Previews: PreviewProvider {
    static var previews: some View {
        StudentInviteScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
