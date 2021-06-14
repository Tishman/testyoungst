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
    
    @State private var dividerHidden: Bool = true
    @State private var swappedWord: UUID?
    
    var body: some View {
        WithViewStore(store.scope(state: \.isLoading)) { viewStore in
            ZStack {
                ScrollView {
                    VStack {
                        
                        HStack {
                            Text(Localizable.dictionaries)
                                .font(.title2)
                            Spacer()
                            
                            WithViewStore(store.scope(state: \.groups.isEmpty)) { viewStore in
                                if !viewStore.state {
                                    Button { viewStore.send(.changeDetail(.addGroup)) } label: {
                                        Label(Localizable.add, systemImage: "plus.app")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        

                        groupsList

                        HStack {
                            Text(Localizable.words)
                                .font(.title2)

                            Spacer()
                            
                            Button { viewStore.send(.addWordOpened) } label: {
                                Label(Localizable.add, systemImage: "plus.app")
                            }
                        }
                        .padding([.horizontal, .top])
                        
                        IfLetStore(store.scope(state: \.lastUpdate)) { store in
                            WithViewStore(store) { viewStore in
                                HStack {
                                    Spacer()
                                    Text(Localizable.lastUpdateTime)
                                    Text(viewStore.state)
                                        .padding(.spacing(.ultraSmall))
                                        .padding(.horizontal, .spacing(.ultraSmall))
                                        .bubbled()
                                }
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.top, .spacing(.ultraSmall))
                            }
                        }
                        
                        wordsList
                    }
                    .padding(.top, .spacing(.medium))
                }

                if viewStore.state {
                    IndicatorView()
                }
            }
            .onAppear { viewStore.send(.viewLoaded) }
            .addRefreshToScrollView { viewStore.send(.refreshList) }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var groupsList: some View {
        WithViewStore(store) { viewStore in
            if viewStore.groups.isEmpty {
                emptyPlaceholder(text: Localizable.emptyGroupsPlaceholder) {
                    viewStore.send(.changeDetail(.addGroup))
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewStore.groups) { element in
                            Button { viewStore.send(.changeDetail(.group(element.id))) } label: {
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
}

struct DictionariesScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DictionariesScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
        }
    }
}
