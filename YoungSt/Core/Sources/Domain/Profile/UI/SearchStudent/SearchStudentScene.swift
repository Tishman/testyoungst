//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct SearchStudentScene: View {
    
    let store: Store<SearchStudentState, SearchStudentAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ScrollView {
                    HeaderActionButton(Localizable.createInviteLink, systemImage: "link.badge.plus") {
                        viewStore.send(.changeDetail(.shareLink))
                    }
                    .padding()
                    
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
                        ForEachStore(store.scope(state: \.profileList, action: SearchStudentAction.profile)) { store in
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
                    .padding([.bottom, .horizontal])
                }
                if viewStore.isInviteSendingLoading {
                    IndicatorView()
                }
            }
            .disabled(viewStore.isInviteSendingLoading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}
