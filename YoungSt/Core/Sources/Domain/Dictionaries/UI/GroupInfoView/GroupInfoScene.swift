//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 01.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct GroupInfoScene: View {
    
    let store: Store<GroupInfoState, GroupInfoAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.stateless) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        topGroupInfo
                        
                        LazyVStack {
                            WithViewStore(store.scope(state: \.words)) { viewStore in
                                ForEach(viewStore.state) {
                                    DictWordView(state: $0.state)
                                }
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                    .addRefreshToScrollView { viewStore.send(.refreshList) }
                    
                    WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                        if viewStore.state {
                            IndicatorView()
                        }
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
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var topGroupInfo: some View {
        IfLetStore(store.scope(state: \.itemInfo)) {
            WithViewStore($0) { viewStore in
                VStack {
                    DictGroupView(id: viewStore.id, size: .medium, state: viewStore.state.state)
                    
                    HStack(spacing: .spacing(.ultraBig)) {
                        Button { viewStore.send(.editOpened(true)) } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                                .padding(.horizontal, 2 * .spacing(.ultraBig))
                                .padding(.vertical, .spacing(.ultraSmall))
                        }
                        
                        Button { viewStore.send(.removeAlertOpened) } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                                .padding(.horizontal, 2 * .spacing(.ultraBig))
                                .padding(.vertical, .spacing(.ultraSmall))
                        }
                    }
                    .padding(.vertical, .spacing(.small))
                    .buttonStyle(InaccentButtonStyle())
                }
                .padding(.vertical)
            }
        }
    }
}

struct GroupInfoScene_Previews: PreviewProvider {
    static var previews: some View {
        let item = DictGroupItem(id: .init(), alias: nil, state: .init(title: "Hello", subtitle: "12 words"))
        return NavigationView {
            GroupInfoScene(store: .init(initialState: .init(info: .item(item), words: [DictWordItem.preview]),
                                        reducer: .empty,
                                        environment: ()))
        }
    }
}
