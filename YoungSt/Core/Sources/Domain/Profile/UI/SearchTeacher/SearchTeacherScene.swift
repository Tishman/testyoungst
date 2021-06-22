//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct SearchTeacherScene: View {
    
    let store: Store<SearchTeacherState, SearchTeacherAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ScrollView {
                    if viewStore.profileList.isEmpty {
                        if viewStore.isSearchLoading {
                            IndicatorView()
                                .padding()
                        } else {
                            Text(Localizable.typeSometingInSearchField)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    
                    LazyVStack(spacing: .spacing(.medium)) {
                        ForEachStore(store.scope(state: \.profileList, action: SearchTeacherAction.profile)) { store in
                            WithViewStore(store) { viewStore in
                                Button { viewStore.send(.selected) } label: {
                                    ProfileInfoView(profileInfo: viewStore.state,
                                                    subtitle: "",
                                                    showChevron: false)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding()
                }
                if viewStore.isInviteSendingLoading {
                    IndicatorView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}
