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
        WithViewStore(store.scope(state: \.shouldShowLoader)) { viewStore in
            LazyVStack(spacing: .spacing(.medium)) {
                WithViewStore(store.scope(state: \.isEmpty)) { viewStore in
                    if viewStore.state {
                        ActionableEmptyPlaceholder(imageSystemName: "magnifyingglass",
                                                   text: Localizable.studentsEmptyPlaceholder) {
                            viewStore.send(.searchStudentsOpened)
                        }
                    }
                }
                
                if viewStore.state {
                    IndicatorView()
                        .frame(maxWidth: .infinity)
                }
                
                studentsView
                invitesView
                
                Spacer(minLength: .spacing(.ultraSmall))
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .frame(maxWidth: .infinity)
        .padding([.top, .horizontal])
    }
    
    @ViewBuilder private var invitesView: some View {
        WithViewStore(store.scope(state: \.incomingInvites.isEmpty)) { viewStore in
            if !viewStore.state {
                sectionHeader(title: Localizable.incomingInvites)
            }
        }
        ForEachStore(store.scope(state: \.incomingInvites, action: StudentsInfoAction.incomingStudentInvite),
                     content: IncomingStudentInviteView.init)
        
        WithViewStore(store.scope(state: \.outcomingInvites.isEmpty)) { viewStore in
            if !viewStore.state {
                sectionHeader(title: Localizable.outcomingInvites)
            }
        }
        ForEachStore(store.scope(state: \.outcomingInvites, action: StudentsInfoAction.outcomingStudentInvite),
                     content: OutcomingStudentInviteView.init)
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3.bold())
            .padding([.top, .horizontal])
    }
    
    @ViewBuilder private var studentsView: some View {
        WithViewStore(store.scope(state: \.students.isEmpty)) { viewStore in
            if !viewStore.state {
                Text(Localizable.students)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3.bold())
                    .padding(.horizontal)
            }
        }
        
        WithViewStore(store.scope(state: \.isEmpty)) { viewStore in
            if !viewStore.state {
                HeaderActionButton(Localizable.searchStudents, systemImage: "magnifyingglass") {
                    viewStore.send(.searchStudentsOpened)
                }
            }
        }
        
        ForEachStore(store.scope(state: \.students, action: StudentsInfoAction.student)) { store in
            WithViewStore(store) { viewStore in
                Button { viewStore.send(.open) } label: {
                    ProfileInfoView(profileInfo: viewStore.state,
                                    subtitle: "",
                                    showChevron: true)
                }
                .buttonStyle(PlainButtonStyle())
                .contextMenu {
                    Button { viewStore.send(.remove) } label: {
                        Label(Localizable.removeStudent, systemImage: "trash")
                    }
                }
            }
        }
    }
    
}

struct StudentsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsInfoView(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
