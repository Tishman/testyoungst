//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities

struct ProfileScene: View {
    
    let store: Store<ProfileState, ProfileAction>
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    CurrentProfileView(store: store.scope(state: \.currentProfileState, action: ProfileAction.currentProfile))
                        .frame(maxWidth: .infinity)
                        .padding([.top, .horizontal])
                }
                .overlay(
                    TopHeaderView(width: globalProxy.size.width,
                                  topSafeAreaInset: globalProxy.safeAreaInsets.top)
                        .opacity(dividerHidden ? 0 : 1)
                )
            }
        }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(store: .init(initialState: .init(userID: .init()), reducer: .empty, environment: ()))
    }
}
