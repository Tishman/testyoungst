//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct InvitesTeacherView: View {
    
    let store: Store<InvitesTeacherState, InvitesTeacherAction>
    
    var body: some View {
        VStack {
            WithViewStore(store) { viewStore in
                if viewStore.isEmpty {
                    ActionableEmptyPlaceholder(imageSystemName: "magnifyingglass", text: Localizable.teacherEmptyPlaceholder) {
                        viewStore.send(.searchTeacherOpened)
                    }
                    .padding(.top, .spacing(.regular))
                } else {
                    if let invite = viewStore.outcoming {
                        VStack {
                            ProfileInfoView(profileInfo: invite.teacher,
                                            subtitle: "",
                                            showChevron: false)
                            
                            Button { viewStore.send(InvitesTeacherAction.inviteAction(id: invite.id, action: .reject)) } label: {
                                Text(Localizable.rejectInvite)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom)
                    } else {
                        HeaderActionButton(Localizable.toSearchTeacher, systemImage: "magnifyingglass") {
                            viewStore.send(.searchTeacherOpened)
                        }
                    }
                    
                    ForEachStore(store.scope(state: \.incoming, action: InvitesTeacherAction.inviteAction)) { store in
                        WithViewStore(store) { viewStore in
                            InviteInfoView(avatarSource: .init(profileInfo: viewStore.teacher),
                                           displayName: viewStore.teacher.primaryField,
                                           secondaryDisplayName: viewStore.teacher.secondaryField,
                                           subtitle: Localizable.askedYouBecomeStudent,
                                           accept: { viewStore.send(.accept) },
                                           reject: { viewStore.send(.reject) })
                        }
                    }
                }
            }
        }
    }
    
}
