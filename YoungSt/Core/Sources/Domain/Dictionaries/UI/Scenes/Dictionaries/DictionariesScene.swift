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
import Coordinator

struct DictionariesScene: View {
    
    let store: Store<DictionariesState, DictionariesAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    @State private var swappedWord: UUID?
    @Environment(\.coordinator) private var coordinator
    
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

                            HStack {
                                Text(Localizable.words)
                                    .font(.title2)

                                Spacer()

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
                                    }
                                }
                            }
                            .padding([.horizontal, .top])

                            wordsList
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
        .onChange(of: contentOffset) { _ in swappedWord = nil }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addGroupButton
            }
        }
        .background(addGroupLink)
        .background(addWordLink)
        .background(groupInfoLink)
        .fixNavigationLinkForIOS14_5()
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var groupsList: some View {
        WithViewStore(store) { viewStore in
            if viewStore.groups.isEmpty {
                emptyPlaceholder(text: Localizable.emptyGroupsPlaceholder) {
                    viewStore.send(.addGroupOpened(true))
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewStore.groups) { element in
                            Button { viewStore.send(.openGroup(element.id)) } label: {
                                DictGroupView(id: element.id, size: .small, state: element.state)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(height: DictGroupView.Size.small.value, alignment: .top)
    }
    
    private var groupInfoLink: some View {
        WithViewStore(store.scope(state: \.groupInfoState)) { viewStore in
            NavigationLink(destination: IfLetStore(store.scope(state: \.groupInfoState, action: DictionariesAction.groupInfo),
                                                   then: GroupInfoScene.init),
                           isActive: viewStore.binding(get: { $0 != nil }, send: .openGroup(nil)),
                           label: {})
        }
    }
    
    private var wordsList: some View {
        WithViewStore(store.scope(state: \.wordsList)) { viewStore in
            if viewStore.state.isEmpty {
                Text(Localizable.emptyWordsPlaceholder)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
                    .frame(maxWidth: .infinity)
                    .padding(.top, .spacing(.regular))
                
            } else {
                LazyVStack {
                    ForEach(viewStore.state) { item in
                        Button { viewStore.send(.wordSelected(item)) } label: {
                            DictWordView(state: item.state)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onDelete(tag: item.id, selection: $swappedWord) {
                            viewStore.send(.deleteWordRequested(item))
                            return false
                        }
                    }
                    .onDelete { indexSet in
                        print(indexSet)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func emptyPlaceholder(text: String, addHandler: @escaping () -> Void) -> some View {
        VStack {
            Button(action: addHandler) {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
            }
            .buttonStyle(InaccentButtonStyle())
            
            Text(text)
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .fixedSize()
        .frame(maxWidth: .infinity)
        .padding(.top, .spacing(.regular))
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
    
    private var addWordLink: some View {
        WithViewStore(store.scope(state: \.addWordState)) { viewStore in
            Color.clear
                .sheet(isPresented: viewStore.binding(get: { $0 != nil }, send: DictionariesAction.addWordOpened(false))) {
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
