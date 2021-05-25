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
import Coordinator

struct GroupInfoScene: View {
    
    let store: Store<GroupInfoState, GroupInfoAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var swappedWord: UUID?
    @State private var dividerHidden: Bool = true
    
    @Namespace private var namespace
    
    private let editAnimationID = "EditAnimation"
    private let editAnimationShapeID = "EditAnimationShape"
    private let deleteAnimationID = "DeleteAnimation"
    private let deleteAnimationShapeID = "DeleteAnimationShape"
    static let controlsToggle = Animation.spring(response: 0.45, dampingFraction: 0.6)
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.scope(state: \.id)) { viewStore in
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
                    .onChange(of: viewStore.state) { _ in viewStore.send(.refreshList) }
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
                    
                    topGroupControls
                }
                .padding(.vertical)
            }
        }
    }
    
    private var openWordAddingButton: some View {
        WithViewStore(store.stateless) { viewStore in
            Button { viewStore.send(.addWordOpened) } label: {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                    .padding(.horizontal, .spacing(.ultraBig))
                    .padding(.vertical, .spacing(.ultraSmall))
            }
            .buttonStyle(InaccentButtonStyle())
        }
    }
    
    private var topGroupControls: some View {
        WithViewStore(store.scope(state: \.controlsState)) { viewStore in
            HStack(spacing: .spacing(.big)) {
                switch viewStore.state {
                case let .edit(editInfo):
                    HStack {
                        TextField(Localizable.name, text: viewStore.binding(get: { _ in editInfo.text }, send: GroupInfoAction.editTextChanged))
                            .frame(minHeight: InaccentButtonStyle.defaultSize)

                        HStack {
                            Spacer()
                            Button {
                                withAnimation(Self.controlsToggle) {
                                    viewStore.send(.editCancelled)
                                }
                            } label: {
                                CrossView()
                                    .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Divider()

                            Button {
                                withAnimation(Self.controlsToggle) {
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
                                    PlainIndicatorView(size: DefaultSize.mediumButton, paddingValue: 0)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        )
                    }
                    .matchedGeometryEffect(id: editAnimationID, in: namespace, anchor: .leading)
                    .buttonStyle(PlainInaccentButtonStyle())
                    .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
                    .padding(.horizontal)
                    .bubbledMatched(id: editAnimationShapeID, in: namespace)
                    .disabled(editInfo.isLoading)
                    
                    
                case let .delete(isLoading):
                    VStack(alignment: .trailing) {
                        Text(Localizable.shouldDeleteGroup)
                            .fixedSize()
                        
                        HStack {
                            Button {
                                withAnimation(Self.controlsToggle) {
                                    viewStore.send(.deleteClosed)
                                }
                            } label: {
                                Text(Localizable.cancel)
                                    .fixedSize()
                            }
                            
                            Button { viewStore.send(.removeGroup) } label: {
                                Text(Localizable.delete)
                                    .foregroundColor(.red)
                                    .fixedSize()
                            }
                        }
                    }
                    .matchedGeometryEffect(id: deleteAnimationID, in: namespace, anchor: .bottomLeading)
                    .overlay(
                        Group {
                            if isLoading {
                                IndicatorView()
                            }
                        }
                    )
                    .buttonStyle(PlainInaccentButtonStyle())
                    .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
                    .padding(.horizontal)
                    .bubbledMatched(id: deleteAnimationShapeID, in: namespace)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .disabled(isLoading)
                    
                case .allVisible:
                    openWordAddingButton
                    
                    Button {
                        withAnimation(Self.controlsToggle) {
                            viewStore.send(.editOpened)
                        }
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                            .matchedGeometryEffect(id: editAnimationID, in: namespace, anchor: .leading)
                            .padding(.horizontal, .spacing(.ultraBig))
                            .padding(.vertical, .spacing(.ultraSmall))
                    }
                    .buttonStyle(PlainInaccentButtonStyle())
                    .bubbledMatched(id: editAnimationShapeID, in: namespace)
                    
                    Button {
                        withAnimation(Self.controlsToggle) {
                            viewStore.send(.deleteOpened)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                            .matchedGeometryEffect(id: deleteAnimationID, in: namespace)
                            .padding(.horizontal, .spacing(.ultraBig))
                            .padding(.vertical, .spacing(.ultraSmall))
                    }
                    .buttonStyle(PlainInaccentButtonStyle())
                    .bubbledMatched(id: deleteAnimationShapeID, in: namespace)
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
            GroupInfoScene(store: .init(initialState: .init(userID: .init(), info: .item(item), words: [DictWordItem.preview]),
                                        reducer: .empty,
                                        environment: ()))
        }
    }
}
