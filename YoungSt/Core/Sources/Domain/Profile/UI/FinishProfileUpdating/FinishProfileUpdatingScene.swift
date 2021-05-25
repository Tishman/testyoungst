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
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.stateless) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
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
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}
