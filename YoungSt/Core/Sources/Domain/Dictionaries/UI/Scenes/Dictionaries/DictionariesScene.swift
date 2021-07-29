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
        WithViewStore(store.scope(state: \.title)) { viewStore in
            ZStack {
                ScrollView {
                    VStack {
                        
                        HStack {
                            Text(Localizable.dictionaries)
                                .font(.title2)
                            Spacer()
                            
                            WithViewStore(store.scope(state: \.groups.isEmpty)) { viewStore in
                                if !viewStore.state {
                                    Button { viewStore.send(.route(.addGroup)) } label: {
                                        Label(Localizable.add, systemImage: "plus.app")
                                    }
                                    .padding(.all, .spacing(.ultraSmall))
                                    .contentShape(RoundedRectangle(cornerRadius: .corner(.small), style: .continuous))
                                    .hoverEffectForIOS()
                                }
                            }
                        }
                        .padding(.horizontal)
                        

                        groupsList

                        HStack {
                            Text(Localizable.words)
                                .font(.title2)

                            Spacer()
                            
                            IfLetStore(store.scope(state: \.lastUpdate)) { store in
                                WithViewStore(store) { viewStore in
                                    Text(Localizable.lastUpdateTime)
                                    Text(viewStore.state)
                                        .padding(.spacing(.ultraSmall))
                                        .padding(.horizontal, .spacing(.ultraSmall))
                                        .bubbled()
                                }
                            }
                            .font(.caption)
                        }
                        .padding([.horizontal, .top])
                        
                        wordsList
                    }
                    .padding(.vertical, .spacing(.medium))
                }

                WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                    if viewStore.state {
                        IndicatorView()
                    }
                }
            }
            .onAppear { viewStore.send(.viewLoaded) }
            .refreshable { viewStore.send(.refreshTriggered) }
        }
        .alert(store.scope(state: \.alert), dismiss: .alertCloseTriggered)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var groupsList: some View {
        WithViewStore(store) { viewStore in
            if viewStore.groups.isEmpty {
                ActionableEmptyPlaceholder(imageSystemName: "plus", text: Localizable.emptyGroupsPlaceholder) {
                    viewStore.send(.route(.addGroup))
                }
                .padding(.top, .spacing(.regular))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewStore.groups) { element in
                            Button { viewStore.send(.route(.group(element.id))) } label: {
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
            HeaderActionButton(Localizable.addWordAction, systemImage: "plus.app.fill", imageScale: .large) {
                viewStore.send(.route(.addWord))
            }
            .padding([.top, .horizontal])
            
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
                        Button { viewStore.send(.route(.word(item.id))) } label: {
                            DictWordView(state: item.state)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onDelete(tag: item.id, selection: $swappedWord) {
                            viewStore.send(.deleteWordTriggered(item.id))
                            return false
                        }
                    }
                }
                .padding(.horizontal)
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
