//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 09.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct GroupsListScene: View {
    
    let store: Store<GroupsListState, GroupsListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ScrollView {
                    LazyVStack(spacing: .spacing(.medium)) {
                        ForEach(viewStore.groups) { group in
                            Button { viewStore.send(.groupSelected(group)) } label: {
                                HStack(spacing: .spacing(.regular)) {
                                    DictGroupView(id: group.id,
                                                  size: .small,
                                                  state: .init(title: group.state.title,
                                                               subtitle: ""))
                                    
                                    VStack(alignment: .leading, spacing: .spacing(.medium)) {
                                        Text(group.state.title)
                                            .foregroundColor(.primary)
                                        
                                        Text(group.state.subtitle)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                
                if viewStore.isLoading {
                    IndicatorView()
                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
        .alert(store.scope(state: \.alertError), dismiss: GroupsListAction.closeSceneTriggered)
        .navigationTitle(Localizable.addToDictionary)
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
    }
    
    private var closeButton: some View {
        WithViewStore(store.stateless) { viewStore in
            CloseButton {
                viewStore.send(.closeSceneTriggered)
            }
        }
    }
}

struct GroupsListScene_Previews: PreviewProvider {
    static var previews: some View {
        GroupsListScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
