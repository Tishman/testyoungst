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
                            
                            groupsList
                            
                            Text(Localizable.words)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.horizontal, .top])
                            
                            WithViewStore(store.scope(state: \.lastUpdate)) { viewStore in
                                if let lastUpdate = viewStore.state {
                                    HStack {
                                        Spacer()
                                        Text(Localizable.lastUpdateTime)
                                        Text(lastUpdate)
                                            .padding(.spacing(.ultraSmall))
                                            .padding(.horizontal, .spacing(.ultraSmall))
                                            .bubbled()
                                    }
                                    .font(.caption)
                                    .padding(.horizontal)
                                }
                            }
                            
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
                .addRefreshToScrollView { viewStore.send(.refreshList) }
            }
        }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addGroupButton
            }
        }
        .background(addGroupLink)
        .alert(store.scope(state: \.errorAlert), dismiss: .alertClosed)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var groupsList: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                WithViewStore(store) { viewStore in
                    ForEach(viewStore.groups) { element in
                        NavigationLink(
                            destination: IfLetStore(store.scope(state: \.groupInfoState, action: DictionariesAction.groupInfo),
                                                    then: GroupInfoScene.init),
                            tag: element.id,
                            selection: viewStore.binding(get: { $0.groupInfoState?.id }, send: DictionariesAction.openGroup)) {
                            DictGroupView(id: element.id, size: .small, state: element.state)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var addGroupLink: some View {
        WithViewStore(store.scope(state: \.addGroupState)) { viewStore in
            NavigationLink(destination: IfLetStore(store.scope(state: \.addGroupState, action: DictionariesAction.addGroup),
                                                   then: AddGroupScene.init),
                           isActive: viewStore.binding(get: { $0 != nil }, send: DictionariesAction.addGroupOpened),
                           label: {})
        }
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
