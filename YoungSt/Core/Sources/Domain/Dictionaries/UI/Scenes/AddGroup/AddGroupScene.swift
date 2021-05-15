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
import Liquid
import Coordinator

struct AddGroupScene: View {
    
    let store: Store<AddGroupState, AddGroupAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        GeometryReader { globalProxy in
            ZStack {
                TrackableScrollView(contentOffset: $contentOffset) {
                    VStack(spacing: .spacing(.big)) {
                        topGroupPreview
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack {
                            WithViewStore(store.scope(state: \.title)) { viewStore in
                                TextField(Localizable.name, text: viewStore.binding(send: AddGroupAction.titleChanged))
                            }
                            .padding()
                            .bubbled()
                            
                            IfLetStore(store.scope(state: \.titleError)) { store in
                                WithViewStore(store) { viewStore in
                                    Text(viewStore.state)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .padding(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
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
                                                              translation: $0.item.destination,
                                                              info: $0.item.description_p))
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, RoundedButtonStyle.minHeight)
                    .padding(.bottom)
                }
                .introspectScrollView {
                    $0.keyboardDismissMode = .interactive
                }
                
                WithViewStore(store.stateless) { viewStore in
                    Button { viewStore.send(.addGroupPressed) } label: {
                        Text(Localizable.addGroupAction)
                    }
                    .buttonStyle(RoundedButtonStyle(style: .filled))
                }
                .padding(.bottom)
                .greedy(aligningContentTo: .bottom)
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
            WithViewStore(store) { viewStore in
                Color.clear
                    .sheet(isPresented: viewStore.binding(get: \.addWordOpened, send: AddGroupAction.addWordOpened)) {
                        coordinator.view(for: .addWord(.init(closeHandler: .init { viewStore.send(.addWordOpened(false)) },
                                                             semantic: .addLater(handler: .init { viewStore.send(.wordAdded($0)) }),
                                                             userID: viewStore.userID,
                                                             groupSelectionEnabled: false)))
                    }
            }
        )
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationTitle(Localizable.addGroupTitle)
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
    }
    
    private var topGroupPreview: some View {
        WithViewStore(store.scope(state: \.title)) { viewStore in
            Text(viewStore.state)
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .lineLimit(3)
        .font(.title3)
        .frame(width: DictGroupView.Size.big.value, height: DictGroupView.Size.big.value)
        .background(
            MeshGradientView(samples: 5, period: 3)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: .corner(.big))
        )
    }
}


struct AddGroupScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddGroupScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
        }
    }
}
