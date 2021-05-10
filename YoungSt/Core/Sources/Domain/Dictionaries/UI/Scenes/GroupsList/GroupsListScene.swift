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
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
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
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
        }
        .alert(store.scope(state: \.alertError), dismiss: GroupsListAction.closeSceneTriggered)
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
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
