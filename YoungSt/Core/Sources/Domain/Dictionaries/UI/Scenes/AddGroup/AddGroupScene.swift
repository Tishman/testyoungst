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
import Meshy
import Coordinator

struct AddGroupScene: View {
    
    let store: Store<AddGroupState, AddGroupAction>
    @State private var swappedWord: UUID?
    
    var body: some View {
        ZStack {
            ScrollView {
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
                        Button { viewStore.send(.route(.addWord)) } label: {
                            HStack(spacing: .spacing(.big)) {
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Text(Localizable.addWordTitle)
                            }
                        }
                        .frame(height: UIFloat(35))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    LazyVStack {
                        ForEachStore(store.scope(state: \.items, action: AddGroupAction.wordAction)) { store in
                            WithViewStore(store) { viewStore in
                                Button { viewStore.send(.selected) } label: {
                                    DictWordView(state: .init(text: viewStore.item.source,
                                                              translation: viewStore.item.destination,
                                                              info: viewStore.item.description_p))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onDelete(tag: viewStore.id, selection: $swappedWord) {
                                    withAnimation {
                                        viewStore.send(.removed)
                                    }
                                    return true
                                }
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
            
            WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                Button { viewStore.send(.addGroupTriggered) } label: {
                    Text(Localizable.create)
                }
                .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.state))
            }
            .padding(.bottom)
            .greedy(aligningContentTo: .bottom)
        }
        .alert(store.scope(state: \.alertError), dismiss: AddGroupAction.alertCloseTriggered)
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
