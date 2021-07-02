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
            WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                if viewStore.state {
                    IndicatorView()
                }
            }
            
            WithViewStore(store.scope(state: \.uiState.isError)) { viewStore in
                if viewStore.state {
                    Button { viewStore.send(.reload) } label: {
                        Text(Localizable.update)
                    }
                }
            }
            
            IfLetStore(store.scope(state: \.uiState.existedState, action: TeacherInfoAction.existed),
                       then: ExistedTeacherView.init)
            
            IfLetStore(store.scope(state: \.uiState.invitesState, action: TeacherInfoAction.invites),
                       then: InvitesTeacherView.init)
        }
        .background(
            WithViewStore(store.stateless) { viewStore in
                Color.clear
                    .onAppear { viewStore.send(.viewAppeared) }
            }
        )
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .padding()
        .buttonStyle(InaccentButtonStyle())
    }
}

struct TeacherInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherInfoView(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
