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

struct OutcomingStudentInviteView: View {
    
    let store: Store<OutcomingStudentInviteState, OutcomingStudentInviteAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            InviteInfoView(avatarSource: .init(profileInfo: viewStore.profile),
                           displayName: viewStore.profile.primaryField,
                           secondaryDisplayName: viewStore.profile.secondaryField,
                           subtitle: "",
                           accept: nil,
                           reject: { viewStore.send(.rejectInvite) })
                .disabled(viewStore.isLoading)
                .overlay(
                    Group {
                        if viewStore.isLoading {
                            IndicatorView()
                        }
                    }
                )
        }
    }
}
