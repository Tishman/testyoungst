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
    static let translationBottom = VerticalAlignment(TranslationCenterAlignment.self)
}


struct AddWordScene: View {
    
    let store: Store<AddWordState, AddWordAction>
    
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    @State private var elementsAppeared: Bool = {
        #if targetEnvironment(macCatalyst)
        // Disabling animationed transition for catalyst
        return true
        #else
        return false
        #endif
    }()
    
    private let addWordInputHeight: CGFloat = UIFloat(130)
    private let translateIndicatorHeight: CGFloat = UIFloat(14)
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        VStack {
                            AddWordLanguageHeader(leftText: viewStore.currentSource.title,
                                                  rightText: viewStore.currentDestination.title,
                                                  buttonRotationFlag: viewStore.leftToRight) {
                                viewStore.send(.swapLanguagesTriggered)
                            }
                            .padding(.bottom, .spacing(.big))
                            
                            if elementsAppeared {
                                sourceInput
                                    .animation(.default)
                                    .transition(contentTransition(delay: 0.25))
                                    .animation(contentTransitionAnimation(delay: 0.25))
                                
                                descriptionInput
                                    .animation(.default)
                                    .transition(contentTransition(delay: 0.35))
                                    .animation(contentTransitionAnimation(delay: 0.35))
                                
                                groupEditing
                                    .animation(.default)
                                    .transition(contentTransition(offset: 10, delay: 0.55))
                                    .animation(contentTransitionAnimation(delay: 0.55))
                            }
                        }
                        .padding()
                        .padding(.bottom, RoundedButtonStyle.minHeight)
                    }
                    .introspectScrollView {
                        $0.keyboardDismissMode = .interactive
                    }
                    
                    Button { viewStore.send(.addTriggered) } label: {
                        Text(Localizable.save)
                    }
                    .buttonStyle(RoundedButtonStyle(style: .filled, isLoading: viewStore.isLoading))
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
        .alert(store.scope(state: \.alertError), dismiss: AddWordAction.alertCloseTriggered)
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                closeButton
            }
        }
        .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
        .onAppear {
            elementsAppeared = true
        }
    }
    
    private func contentTransition(offset: CGFloat = 25, delay: Double) -> AnyTransition {
        .opacity
            .combined(with: .offset(x: 0, y: offset))
            .combined(with: .scale(scale: 0.95))
            .animation(contentTransitionAnimation(delay: delay))
    }
    
    private func contentTransitionAnimation(delay: Double) -> Animation {
        .spring().speed(1.25).delay(delay)
    }
    
    private var sourceInput: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .translationBottom)) {
                VStack {
                    AddWordInputView(subtitle: Localizable.word,
                                     lineLimit: 0,
                                     delegate: AddWordTextDelegate { viewStore.send(.translateTriggered) },
                                     currentText: viewStore.binding(get: \.sourceText, send: AddWordAction.sourceChanged),
                                     forceFocused: viewStore.binding(get: \.sourceFieldForceFocused, send: AddWordAction.sourceInputFocusChanged))
                        .frame(height: addWordInputHeight * 3 / 4)

                    if let sourceError = viewStore.sourceError {
                        Text(sourceError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Divider()
                    
                    VStack(alignment: .leading, spacing: .spacing(.ultraSmall)) {
                        HStack {
                            Text(Localizable.translation)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            if viewStore.isTranslateLoading {
                                PlainIndicatorView(size: translateIndicatorHeight)
                            }
                        }
                        .frame(minHeight: translateIndicatorHeight)
                        
                        TextEditingView(text: viewStore.binding(get: \.translationText, send: AddWordAction.translationChanged),
                                        forceFocused: .constant(false),
                                        delegate: nil)
                            .frame(height: UIFloat(60))
                            .alignmentGuide(.translationBottom) { $0[.bottom] }
                            .background(
                                Text(viewStore.translationText.isEmpty ? Localizable.noTranslation : "")
                                    .foregroundColor(.secondary)
                                    .greedy(aligningContentTo: .topLeading)
                            )
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
                
                Button { viewStore.send(.auditionTriggered) } label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                        .alignmentGuide(.translationBottom) { $0[.bottom] }
                        .padding([.trailing])
                        .padding([.vertical, .leading], .spacing(.small))
                        .foregroundColor(Asset.Colors.greenDark.color.swiftuiColor)
                }
                .buttonStyle(defaultButtonStyle)
            }
        }
    }
    
    
    
    private var descriptionInput: some View {
        WithViewStore(store.scope(state: \.descriptionText)) { viewStore in
            AddWordInputView(subtitle: Localizable.wordDescription,
                             lineLimit: 4,
                             delegate: nil,
                             currentText: viewStore.binding(send: AddWordAction.descriptionChanged),
                             forceFocused: .constant(false))
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
                    Button { viewStore.send(.route(.selectGroup)) } label: {
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
                            Button { viewStore.send(.removeSelectedGroupTriggered) } label: {
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
}

struct AddWordScene_Previews: PreviewProvider {
    static var previews: some View {
        AddWordScene(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
