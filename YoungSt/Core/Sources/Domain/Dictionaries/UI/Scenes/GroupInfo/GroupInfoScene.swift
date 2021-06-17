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

private extension HorizontalAlignment {
    struct AddWordCenterAlignment: AlignmentID {
        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            dimensions[.leading]
        }
    }
    
    static let addWordCenter = HorizontalAlignment(AddWordCenterAlignment.self)
}

struct GroupInfoScene: View {
    
    let store: Store<GroupInfoState, GroupInfoAction>
    
    @State private var swappedWord: UUID?
    
    private let emptyWordsArrowWidth = UIFloat(44)
    private let emptyWordsArrowDefaultAlpha = 0.66
    
    @Namespace private var namespace
    
    private let editAnimationID = "EditAnimation"
    private let editAnimationShapeID = "EditAnimationShape"
    private let deleteAnimationID = "DeleteAnimation"
    private let deleteAnimationShapeID = "DeleteAnimationShape"
    static let controlsToggle = Animation.spring().speed(1.25)
    
    var body: some View {
        WithViewStore(store.scope(state: \.title)) { viewStore in
            ZStack {
                ScrollView {
                    topGroupInfo
                    
                    LazyVStack {
                        WithViewStore(store.scope(state: \.wordsList)) { viewStore in
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
            .navigationTitle(viewStore.state ?? "")
        }
        .alert(store.scope(state: \.alert), dismiss: .alertClosed)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var wordListIsEmptyInfo: some View {
        (Text(Localizable.youShouldAddWordTitle).bold() + Text("\n") + Text(Localizable.youShouldAddWordDescription))
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
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
        }
        .buttonStyle(InaccentButtonStyle())
        .alignmentGuide(.addWordCenter) { $0[HorizontalAlignment.center] }
    }
    
    private var topGroupControls: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: .spacing(.ultraSmall)) {
                VStack(alignment: viewStore.controlsState.isAllVisible ? .addWordCenter : .leading) {
                    switch viewStore.controlsState {
                    case let .edit(editInfo):
                        editExpandedControl(viewStore: viewStore, editInfo: editInfo)
                        
                    case let .delete(isLoading):
                        deleteExpandedControl(viewStore: viewStore, isLoading: isLoading)
                        
                    case .allVisible:
                        allControlsVisible(viewStore: viewStore)
                    }
                    
                    if viewStore.wordsList.isEmpty {
                        emptyWordsArrowImage
                            .opacity(viewStore.controlsState.isAllVisible ? emptyWordsArrowDefaultAlpha : 0)
                    }
                }
                
                if viewStore.wordsList.isEmpty {
                    wordListIsEmptyInfo
                }
            }
            
        }
        .buttonStyle(PlainInaccentButtonStyle())
        .padding(.vertical, .spacing(.small))
        .padding(.horizontal)
    }
    
    private func allControlsVisible(viewStore: ViewStore<GroupInfoState, GroupInfoAction>) -> some View {
        HStack(spacing: .spacing(.big)) {
            openWordAddingButton
                .transition(.move(edge: .leading))
            
            Button {
                withAnimation(Self.controlsToggle) {
                    viewStore.send(.editOpened)
                }
            } label: {
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
            }
            .matchedGeometryEffect(id: editAnimationID, in: namespace, anchor: .leading)
            .padding(.horizontal, .spacing(.ultraBig))
            .padding(.vertical, .spacing(.ultraSmall))
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
            }
            .matchedGeometryEffect(id: deleteAnimationID, in: namespace)
            .padding(.horizontal, .spacing(.ultraBig))
            .padding(.vertical, .spacing(.ultraSmall))
            .bubbledMatched(id: deleteAnimationShapeID, in: namespace)
        }
    }
    
    private func deleteExpandedControl(viewStore: ViewStore<GroupInfoState, GroupInfoAction>, isLoading: Bool) -> some View {
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
        .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
        .padding(.horizontal)
        .bubbledMatched(id: deleteAnimationShapeID, in: namespace)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(isLoading)
    }
    
    private func editExpandedControl(viewStore: ViewStore<GroupInfoState, GroupInfoAction>, editInfo: GroupInfoState.EditState) -> some View {
        HStack {
            TextField(Localizable.name, text: viewStore.binding(get: { _ in editInfo.text }, send: GroupInfoAction.editTextChanged))
                .frame(minHeight: InaccentButtonStyle.defaultSize)
            
            HStack {
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
                    .frame(height: InaccentButtonStyle.defaultSize)
                
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
        .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
        .padding(.horizontal)
        .bubbledMatched(id: editAnimationShapeID, in: namespace)
        .disabled(editInfo.isLoading)
    }
    
    private var emptyWordsArrowImage: some View {
        Asset.Images.arrow.swiftUI
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.secondary)
            .frame(maxWidth: emptyWordsArrowWidth)
            .offset(x: emptyWordsArrowWidth * 0.2, y: 0) // arrow points to 0.2 of image width
            .alignmentGuide(.addWordCenter) { $0[HorizontalAlignment.center] }
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
