//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct ProfileScene: View {
    
    let store: Store<ProfileState, ProfileAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    CurrentProfileView(store: store.scope(state: \.currentProfileState, action: ProfileAction.currentProfile))
                        .frame(maxWidth: .infinity)
                        .padding([.top, .horizontal])
                    
                    topControls
                    tabContent
                }
            }
            .fixFlickering()
            .onAppear { viewStore.send(.viewAppeared) }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewStore.currentProfileState.isInfoProvided {
                        Button { viewStore.send(.changeDetail(.editProfile)) } label: {
                            Image(systemName: "pencil.circle")
                        }
                        .buttonStyle(defaultButtonStyle)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var topControls: some View {
        WithViewStore(store) { viewStore in
            
            HStack {
                Text(Localizable.currentRole)
                
                Menu {
                    Button { viewStore.send(.profileTypeChanged(.student)) } label: {
                        Text(Localizable.student)
                    }
                    Button { viewStore.send(.profileTypeChanged(.teacher)) } label: {
                        Text(Localizable.teacher)
                    }
                } label: {
                    HStack {
                        Text(viewStore.profileType.title)
                        Image(systemName: "chevron.down")
                    }
                    .font(.body)
                    .padding(.vertical, .spacing(.small))
                    .padding(.horizontal)
                    .bubbled()
                }
            }
        }
    }
    
    private var tabContent: some View {
        WithViewStore(store.scope(state: \.profileType)) { viewStore in
            switch viewStore.state {
            case .student:
                TeacherInfoView(store: store.scope(state: \.teacherInfoState, action: ProfileAction.teacherInfo))
            case .teacher:
                StudentsInfoView(store: store.scope(state: \.studentsInfoState, action: ProfileAction.studentsInfo))
            }
        }
    }
    
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(store: .init(initialState: .init(userID: .init()), reducer: .empty, environment: ()))
    }
}
