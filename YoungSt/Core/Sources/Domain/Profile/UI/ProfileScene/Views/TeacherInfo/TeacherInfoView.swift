//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 15.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct TeacherInfoView: View {
    
    let store: Store<TeacherInfoState, TeacherInfoAction>
    
    var body: some View {
        VStack {
            WithViewStore(store) { viewStore in
                Group {
                    switch viewStore.state {
                    case .loading:
                        IndicatorView()
                    case .empty:
                        Text("You dont have teacher")
                    case .error:
                        Button { viewStore.send(.reload) } label: {
                            Text(Localizable.update)
                        }
                        
                    case let .exists(teacher):
                        VStack {
                            VStack(alignment: .leading, spacing: .spacing(.medium)) {
                                VStack(alignment: .leading) {
                                    Text(teacher.profile.displayName)
                                        .font(.title3.bold())
                                    Text(teacher.profile.email)
                                }
                                if !teacher.inviteAccepted {
                                    Text(Localizable.teacherNotAcceptedInviteYet)
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bubbled()
                            
                            Button { viewStore.send(.removeTeacher) } label: {
                                Text(teacher.inviteAccepted ? Localizable.removeTeacher : Localizable.cancelInvite)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .onAppear { viewStore.send(.viewAppeared) }
            }
        }
        .padding()
        .buttonStyle(InaccentButtonStyle())
    }
}

struct TeacherInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherInfoView(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
