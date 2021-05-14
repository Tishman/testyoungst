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


private extension VerticalAlignment {
    struct TranslationCenterAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[VerticalAlignment.center]
        }
    }
    
    /// Aligning translate button with translation result.
    /// They are in different view hierarchy for proper paddings and custom button tap area
    static let translationCenter = VerticalAlignment(TranslationCenterAlignment.self)
}


struct AddWordScene: View {
    
    let store: Store<AddWordState, AddWordAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    private let addWordInputHeight: CGFloat = 130
    
    var body: some View {
        NavigationView {
            GeometryReader { globalProxy in
                WithViewStore(store) { viewStore in
                    ZStack {
                        TrackableScrollView(contentOffset: $contentOffset) {
                            VStack {
                                AddWordLanguageHeader(leftText: viewStore.currentSource.title,
                                                      rightText: viewStore.currentDestination.title) {
                                    viewStore.send(.translatePressed)
                                }
                                .padding(.bottom, .spacing(.big))
                                
                                sourceInput
                                
                                descriptionInput
                                
                                groupEditing
                            }
                            .padding()
                            .padding(.bottom, RoundedButtonStyle.minHeight)
                        }
                        .introspectScrollView {
                            $0.keyboardDismissMode = .interactive
                        }
                        
                        Button { viewStore.send(.addPressed) } label: {
                            Text(viewStore.editingMode ? Localizable.editWordTitle : Localizable.addWordAction)
                        }
                        .buttonStyle(RoundedButtonStyle(style: .filled))
                        .padding(.bottom)
                        .greedy(aligningContentTo: .bottom)
                    }
                    .overlay(
                        TopHeaderView(width: globalProxy.size.width,
                                      topSafeAreaInset: globalProxy.safeAreaInsets.top)
                            .opacity(dividerHidden ? 0 : 1)
                    )
                    .navigationTitle(viewStore.editingMode ? Localizable.editWordTitle : Localizable.addWordTitle)
                }
            }
            .background(
                WithViewStore(store.stateless) { viewStore in
                    Color.clear.onAppear { viewStore.send(.viewAppeared) }
                }
            )
            .background(groupsListLink)
            .alert(store.scope(state: \.alertError), dismiss: AddWordAction.alertClosePressed)
            .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
            .fixNavigationLinkForIOS14_5()
        }
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
    }
    
    private var sourceInput: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .translationCenter)) {
                VStack {
                    AddWordInputView(subtitle: Localizable.word,
                                     lineLimit: 1,
                                     currentText: viewStore.binding(get: \.sourceText, send: AddWordAction.sourceChanged))
                        .frame(height: addWordInputHeight * 3 / 4)
                    
                    if let sourceError = viewStore.sourceError {
                        Text(sourceError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: .spacing(.ultraSmall)) {
                        Text(Localizable.translation)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text(viewStore.translationText.isEmpty ? Localizable.noTranslation : viewStore.translationText)
                            .alignmentGuide(.translationCenter) { $0[VerticalAlignment.center] }
                            .foregroundColor(viewStore.translationText.isEmpty ? .secondary : .primary)
                            .font(.body)
                            // Padding to not overlap with translate button
                            .padding(.trailing, InaccentButtonStyle.defaultSize + .spacing(.medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .bubbled()
                
                Button { viewStore.send(.translatePressed) } label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                        .padding([.trailing])
                        .padding([.vertical, .leading], .spacing(.small))
                }
                .alignmentGuide(.translationCenter) { $0[VerticalAlignment.center] }
            }
        }
    }
    
    private var descriptionInput: some View {
        WithViewStore(store.scope(state: \.descriptionText)) { viewStore in
            AddWordInputView(subtitle: Localizable.wordDescription,
                             lineLimit: 4,
                             currentText: viewStore.binding(send: AddWordAction.descriptionChanged))
                .padding()
                .frame(height: addWordInputHeight)
                .frame(maxWidth: .infinity)
                .bubbled()
        }
    }
    
    private var groupEditing: some View {
        WithViewStore(store) { viewStore in
            HStack {
                if viewStore.info.groupSelectionEnabled {
                    Button { viewStore.send(.groupsOpened(true)) } label: {
                        Image(systemName: "rectangle.stack.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: InaccentButtonStyle.defaultSize,
                                   height: InaccentButtonStyle.defaultSize)
                    }
                    .buttonStyle(InaccentButtonStyle())
                }
                if let group = viewStore.selectedGroup {
                    HStack(spacing: 0) {
                        Text(group.title)
                            .font(.body)
                        
                        if viewStore.info.groupSelectionEnabled {
                            Button { viewStore.send(.removeSelectedGroupPressed) } label: {
                                CrossView()
                                    .frame(width: DefaultSize.smallButton, height: DefaultSize.smallButton)
                                    .padding(.spacing(.small))
                            }
                        }
                    }
                    .padding(viewStore.info.groupSelectionEnabled ? .leading : .all, .spacing(.medium))
                    .bubbled()
                }
                Spacer()
            }
        }
    }
    
    private var closeButton: some View {
        WithViewStore(store.stateless) { viewStore in
            CloseButton {
                viewStore.send(.closeSceneTriggered)
            }
        }
    }
    
    private var groupsListLink: some View {
        WithViewStore(store.scope(state: \.groupsListState)) { viewStore in
            NavigationLink(destination: IfLetStore(store.scope(state: \.groupsListState, action: AddWordAction.groupsList), then: GroupsListScene.init),
                           isActive: viewStore.binding(get: { $0 != nil }, send: AddWordAction.groupsOpened(false)),
                           label: {})
        }
    }
}

struct AddWordScene_Previews: PreviewProvider {
    static var previews: some View {
        AddWordScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
