//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct IncomingStudentInviteView: View {
    
    let store: Store<IncomingStudentInviteState, IncomingStudentInviteAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            InviteInfoView(avatarSource: .init(profileInfo: viewStore.student),
                           displayName: viewStore.student.primaryField,
                           secondaryDisplayName: viewStore.student.secondaryField,
                           subtitle: "",
                           accept: { viewStore.send(.acceptInvite) },
                           reject: { viewStore.send(.rejectInvite) })
                .disabled(viewStore.loading != nil)
                .overlay(
                    Group {
                        if viewStore.loading != nil {
                            IndicatorView()
                        }
                    }
                )
        }
    }
}

struct IncomingStudentInviteView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingStudentInviteView(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
