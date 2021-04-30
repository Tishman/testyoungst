//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 28.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct DictionariesScene: View {
    
    let store: Store<DictionariesState, DictionariesAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        VStack {
                            Text(Localizable.dictionaries)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    WithViewStore(store.scope(state: \.groups)) { viewStore in
                                        ForEach(viewStore.state) {
                                            DictGroupView(state: $0.state)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Text(Localizable.words)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            LazyVStack {
                                WithViewStore(store.scope(state: \.words)) { viewStore in
                                    ForEach(viewStore.state) {
                                        DictWordView(state: $0.state)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, .spacing(.medium))
                    }
                    
                    if viewStore.state {
                        IndicatorView()
                    }
                }
                .overlay(
                    TopHeaderView(width: globalProxy.size.width,
                                  topSafeAreaInset: globalProxy.safeAreaInsets.top)
                        .opacity(dividerHidden ? 0 : 1)
                )
                .onAppear { viewStore.send(.viewLoaded) }
                .introspectScrollView { scrollView in
                    guard UIDevice.current.userInterfaceIdiom != .mac else { return }
                    let refresh: UIRefreshControl
                    if let existed = scrollView.refreshControl {
                        refresh = existed
                    } else {
                        refresh = UIRefreshControl(frame: .zero, primaryAction: .init(handler: { [weak scrollView] _ in
                            viewStore.send(.refreshList)
                            scrollView?.refreshControl?.endRefreshing()
                        }))
                        scrollView.refreshControl = refresh
                    }
                }
            }
        }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addGroupButton
            }
        }
        .background(
            WithViewStore(store.scope(state: \.addGroupState)) { viewStore in
                NavigationLink(destination: IfLetStore(store.scope(state: \.addGroupState, action: DictionariesAction.addGroup),
                                                       then: AddGroupScene.init),
                               isActive: viewStore.binding(get: { $0 != nil }, send: DictionariesAction.addGroupOpened),
                               label: {})
            }
        )
        .alert(store.scope(state: \.errorAlert), dismiss: .alertClosed)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var addGroupButton: some View {
        WithViewStore(store.scope(state: \.addGroupState)) { viewStore in
            Button { viewStore.send(.addGroupOpened(true)) } label: {
                Image(systemName: "plus.app")
            }
            .frame(width: DefaultSize.navigationBarButton,
                   height: DefaultSize.navigationBarButton)
        }
    }
    
    private var addWordButton: some View {
        WithViewStore(store.scope(state: \.addWordState)) { viewStore in
            Button { viewStore.send(.addWordOpened(true)) } label: {
                Image(systemName: "plus.app")
            }
            .frame(width: DefaultSize.navigationBarButton,
                   height: DefaultSize.navigationBarButton)
            .sheet(isPresented: viewStore.binding(get: { $0 != nil }, send: DictionariesAction.addWordOpened)) {
                IfLetStore(store.scope(state: \.addWordState, action: DictionariesAction.addWord),
                           then: AddWordScene.init)
            }
        }
    }
    
}

struct DictionariesScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DictionariesScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
        }
    }
}
