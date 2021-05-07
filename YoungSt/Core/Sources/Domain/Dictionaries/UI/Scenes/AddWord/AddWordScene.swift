//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities
import Introspect

struct AddWordScene: View {
    
    let store: Store<AddWordState, AddWordAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        NavigationView {
            GeometryReader { globalProxy in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        VStack {
                            WithViewStore(store) { viewStore in
                                AddWordLanguageHeader(leftText: viewStore.currentSource.title,
                                                      rightText: viewStore.currentDestination.title) {
                                    viewStore.send(.translatePressed)
                                }
                            }
                            .padding(.bottom, .spacing(.big))
                            
                            WithViewStore(store.scope(state: \.sourceText)) { viewStore in
                                AddWordInputView(subtitle: Localizable.word,
                                                 currentText: viewStore.binding(send: AddWordAction.sourceChanged))
                            }
                            
                            WithViewStore(store.scope(state: \.localTranslationDownloading)) { viewStore in
                                if viewStore.state {
                                    HStack {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                        Text("Downloading local translations")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                }
                            }
                            
                            WithViewStore(store.scope(state: \.descriptionText)) { viewStore in
                                AddWordInputView(subtitle: Localizable.wordDescription,
                                                 currentText: viewStore.binding(send: AddWordAction.descriptionChanged))
                            }
                            
                            HStack {
                                WithViewStore(store.stateless) { viewStore in
                                    Button { viewStore.send(.groupsOpened(true)) } label: {
                                        Image(systemName: "rectangle.stack.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: InaccentButtonStyle.defaultSize,
                                                   height: InaccentButtonStyle.defaultSize)
                                    }
                                    .buttonStyle(InaccentButtonStyle())
                                }
                                Spacer()
                            }
                            .padding(.top)
                        }
                        .padding()
                        .padding(.bottom, RoundedButtonStyle.minHeight)
                    }
                    .introspectScrollView {
                        $0.keyboardDismissMode = .interactive
                    }
                    
                    WithViewStore(store.stateless) { viewStore in
                        Button { viewStore.send(.addPressed) } label: {
                            Text(Localizable.addWordAction)
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
            }
            .background(
                WithViewStore(store.stateless) { viewStore in
                    Color.clear
                        .onAppear { viewStore.send(.viewAppeared) }
                }
            )
            .alert(store.scope(state: \.alertError), dismiss: AddWordAction.alertClosePressed)
            .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
            .navigationTitle(Localizable.addWordTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
            }
        }
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
    }
    
    private var closeButton: some View {
        WithViewStore(store.stateless) { viewStore in
            CloseButton {
                viewStore.send(.closeSceneTriggered)
            }
        }
    }
    
}

struct AddWordScene_Previews: PreviewProvider {
    static var previews: some View {
        AddWordScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
