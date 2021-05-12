//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 01.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct GroupInfoScene: View {
    
    let store: Store<GroupInfoState, GroupInfoAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var swappedWord: UUID?
    @State private var dividerHidden: Bool = true
    
    @Namespace private var groupInfoNamespace
    @State private var flag: Bool = true
    private let editAnimationID = "EditAnimation"
    static let editAnimation = Animation.spring(response: 0.45, dampingFraction: 0.6)
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.stateless) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        topGroupInfo
                        
                        LazyVStack {
                            WithViewStore(store.scope(state: \.wordsList)) { viewStore in
                                ForEach(viewStore.state) { item in
                                    DictWordView(state: item.state)
                                        .onDelete(tag: item.id, selection: $swappedWord) {
                                            viewStore.send(.deleteWordRequested(item))
                                            return false
                                        }
                                }
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                    .addRefreshToScrollView { viewStore.send(.refreshList) }
                    
                    WithViewStore(store.scope(state: \.isLoading)) { viewStore in
                        if viewStore.state {
                            IndicatorView()
                        }
                    }
                }
                .onAppear { viewStore.send(.viewAppeared) }
            }
            .overlay(
                TopHeaderView(width: globalProxy.size.width,
                              topSafeAreaInset: globalProxy.safeAreaInsets.top)
                    .opacity(dividerHidden ? 0 : 1)
            )
        }
        .onChange(of: contentOffset) { _ in swappedWord = nil }
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var topGroupInfo: some View {
        IfLetStore(store.scope(state: \.itemInfo)) {
            WithViewStore($0) { viewStore in
                VStack {
                    DictGroupView(id: viewStore.id, size: .medium, state: viewStore.state.state)
                    
                    editNameView
                }
                .padding(.vertical)
            }
        }
    }
    
    private var editNameView: some View {
        WithViewStore(store.scope(state: \.editState)) { viewStore in
            HStack(spacing: .spacing(.ultraBig)) {
                HStack {
                    if let editInfo = viewStore.state {
                        HStack {
                            TextField(Localizable.name, text: viewStore.binding(get: { $0?.text ?? "" }, send: GroupInfoAction.editTextChanged))
                                .frame(minHeight: InaccentButtonStyle.defaultSize)
                            
                            HStack {
                                Button {
                                    withAnimation(Self.editAnimation) {
                                        viewStore.send(.editCancelled)
                                    }
                                } label: {
                                    CrossView()
                                        .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider()
                                
                                Button {
                                    withAnimation(Self.editAnimation) {
                                        viewStore.send(.editCommited)
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                                }
                                .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                            }
                            .opacity(editInfo.isLoading ? 0 : 1)
                            .overlay(
                                Group {
                                    if editInfo.isLoading {
                                        IndicatorView(size: DefaultSize.mediumButton, paddingValue: .spacing(.ultraSmall))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                            )
                        }
                        .buttonStyle(PlainInaccentButtonStyle())
                        .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
                        .padding(.horizontal)
                        .matchedGeometryEffect(id: editAnimationID, in: groupInfoNamespace, anchor: .leading)
                        .disabled(editInfo.isLoading)
                    } else {
                        Button {
                            withAnimation(Self.editAnimation) {
                                viewStore.send(.editOpened(true))
                            }
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                                .padding(.horizontal, 2 * .spacing(.ultraBig))
                                .padding(.vertical, .spacing(.ultraSmall))
                        }
                        .buttonStyle(PlainInaccentButtonStyle())
                        .matchedGeometryEffect(id: editAnimationID, in: groupInfoNamespace, anchor: .leading)
                    }
                }
                .bubbled()
                
                if viewStore.state == nil {
                    Button { viewStore.send(.removeAlertOpened) } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                            .padding(.horizontal, 2 * .spacing(.ultraBig))
                            .padding(.vertical, .spacing(.ultraSmall))
                    }
                    .buttonStyle(InaccentButtonStyle())
                }
            }
            .padding(.vertical, .spacing(.small))
            .padding(.horizontal)
        }
    }
}

struct GroupInfoScene_Previews: PreviewProvider {
    static var previews: some View {
        let item = DictGroupItem(id: .init(), alias: nil, state: .init(title: "Hello", subtitle: "12 words"))
        return NavigationView {
            GroupInfoScene(store: .init(initialState: .init(info: .item(item), words: [DictWordItem.preview]),
                                        reducer: .empty,
                                        environment: ()))
        }
    }
}
