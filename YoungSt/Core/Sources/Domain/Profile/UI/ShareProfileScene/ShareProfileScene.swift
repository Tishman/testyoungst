//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct ShareProfileScene: View {
    
    let store: Store<ShareProfileState, ShareProfileAction>
    
    var body: some View {
        ScrollView {
            VStack {
                Text(Localizable.shareProfileTitle)
                    .font(.title)
                    .padding(.top, .spacing(.custom(160)))
                Text(Localizable.shareProfileDescription)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            
            
            WithViewStore(store.scope(state: \.url)) { viewStore in
                if viewStore.state.isEmpty {
                    IndicatorView()
                } else {
                    Text(viewStore.state)
                        .lineLimit(nil)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bubbled()
                        .padding(.top, .spacing(.custom(80)))
                        .padding(.horizontal)
                    
                    WithViewStore(store.scope(state: \.shareURL)) { viewStore in
                        HStack {
                            Spacer()
                            Button { viewStore.send(.copy) } label: {
                                Text(Localizable.copy)
                            }
                            
                            Button { viewStore.send(.shareOpened(true)) } label: {
                                Text(Localizable.share)
                            }
                            .sheet(isPresented: viewStore.binding(get: { $0 != nil }, send: ShareProfileAction.shareOpened)) {
                                IfLetStore(store.scope(state: \.shareURL)) { store in
                                    WithViewStore(store) { viewStore in
                                        ShareSheet(activityItems: [viewStore.state])
                                    }
                                }
                            }
                        }
                        .buttonStyle(InaccentButtonStyle())
                        .padding(.horizontal)
                    }
                }
            }
            
        }
        .background(
            WithViewStore(store.stateless) { viewStore in
                Color.clear.onAppear { viewStore.send(.viewAppeared) }
            }
        )
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
    }
}

struct ShareProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ShareProfileScene(store: .init(initialState: .init(), reducer: .empty, environment: ()))
    }
}
