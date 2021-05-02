//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 30.04.2021.
//

import SwiftUI
import Resources
import Utilities
import ComposableArchitecture

struct AddGroupScene: View {
    
    let store: Store<AddGroupState, AddGroupAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack(spacing: .spacing(.big)) {
                        WithViewStore(store) { viewStore in
                            DictGroupView(id: viewStore.tmpID,
                                          size: .big,
                                          state: .init(title: viewStore.title.isEmpty ? Localizable.unnamed : viewStore.title,
                                                       subtitle: ""))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        WithViewStore(store.scope(state: \.title)) { viewStore in
                            TextField(Localizable.name, text: viewStore.binding(send: AddGroupAction.titleChanged))
                        }
                        .padding()
                        .bubbled()
                        
                        WithViewStore(store.stateless) { viewStore in
                            Button { viewStore.send(.addWordOpened(true)) } label: {
                                HStack(spacing: .spacing(.big)) {
                                    Image(systemName: "plus.app.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text(Localizable.addWordTitle)
                                }
                            }
                            .frame(height: 35)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                        
                        LazyVStack {
                            WithViewStore(store.scope(state: \.items)) { viewStore in
                                ForEach(viewStore.state) {
                                    DictWordView(state: .init(text: $0.item.source,
                                                              info: $0.item.destination))
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, RoundedButtonStyle.minHeight)
                    .padding(.bottom)
                }
                .introspectScrollView {
                    $0.keyboardDismissMode = .onDrag
                }
                
                WithViewStore(store.stateless) { viewStore in
                    Button { viewStore.send(.addGroupPressed) } label: {
                        Text(Localizable.addGroupAction)
                    }
                    .buttonStyle(RoundedButtonStyle(style: .filled))
                }
                .padding(.bottom)
                .greedy(aligningContentTo: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
            
            WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                if viewStore.state {
                    IndicatorView()
                        .position(x: globalProxy.size.width / 2,
                                  y: globalProxy.size.height / 2)
                }
            }
        }
        .alert(store.scope(state: \.alertError), dismiss: AddGroupAction.alertClosePressed)
        .background(
            WithViewStore(store.scope(state: \.addWordState)) { viewStore in
                Color.clear
                    .sheet(isPresented: viewStore.binding(get: { $0 != nil }, send: AddGroupAction.addWordOpened)) {
                        IfLetStore(store.scope(state: \.addWordState, action: AddGroupAction.addWord),
                                   then: AddWordScene.init)
                    }
            }
        )
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationTitle(Localizable.addGroupTitle)
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
    }
}


struct AddGroupScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddGroupScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
        }
    }
}
