//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities
import Coordinator

struct StudentsInfoView: View {
    
    let store: Store<StudentsInfoState, StudentsInfoAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            LazyVStack(spacing: .spacing(.medium)) {
                if viewStore.shouldShowLoader {
                    IndicatorView()
                        .frame(maxWidth: .infinity)
                }
                
                if !viewStore.studentsInvites.isEmpty {
                    Text(Localizable.invites)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    ForEachStore(store.scope(state: \.studentsInvites, action: StudentsInfoAction.incomingStudentInvite),
                                 content: IncomingStudentInviteView.init)
                }
                
                if !viewStore.students.isEmpty {
                    Text(Localizable.students)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    ForEach(viewStore.students) { profile in
                        Button { viewStore.send(.studentOpened(profile.id)) } label: {
                            ProfileInfoView(avatarSource: .init(profileInfo: profile),
                                            displayName: profile.displayName,
                                            secondaryDisplayName: profile.secondaryDisplayName,
                                            subtitle: "",
                                            showChevron: true)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button { viewStore.send(.removeStudentTriggered(profile.id)) } label: {
                                Label(Localizable.removeStudent, systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .frame(maxWidth: .infinity)
        .padding([.top, .horizontal])
    }
    
}

struct StudentsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsInfoView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
