//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct ProfileScene: View {
    
    let store: Store<ProfileState, ProfileAction>
    @State private var contentOffset: CGFloat = 0
    @State private var dividerHidden: Bool = true
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store.scope(state: \.currentProfileState.isInfoProvided)) { viewStore in
                ZStack {
                    TrackableScrollView(contentOffset: $contentOffset) {
                        VStack {
                            CurrentProfileView(store: store.scope(state: \.currentProfileState, action: ProfileAction.currentProfile))
                                .frame(maxWidth: .infinity)
                                .padding([.top, .horizontal])
                            
                            topControls
                            tabContent
                        }
                    }
                    .overlay(
                        TopHeaderView(width: globalProxy.size.width,
                                      topSafeAreaInset: globalProxy.safeAreaInsets.top)
                            .opacity(dividerHidden ? 0 : 1)
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if viewStore.state {
                            Button { viewStore.send(.editProfileOpened) } label: {
                                Image(systemName: "pencil.circle")
                            }
                        }
                    }
                }
            }
        }
        .fixNavigationLinkForIOS14_5()
        .background(fillInfoLink)
        .background(editProfileLink)
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var fillInfoLink: some View {
        WithViewStore(store.scope(state: \.fillInfoState)) { viewStore in
            NavigationLink(destination: IfLetStore(store.scope(state: \.fillInfoState, action: ProfileAction.fillProfileInfo),
                                                   then: FinishProfileUpdatingScene.init),
                           isActive: viewStore.binding(get: { $0 != nil }, send: ProfileAction.fillInfoClosed),
                           label: {})
        }
    }
    
    private var editProfileLink: some View {
        WithViewStore(store.scope(state: \.editProfileState)) { viewStore in
            NavigationLink(destination: IfLetStore(store.scope(state: \.editProfileState, action: ProfileAction.editProfile),
                                                   then: EditProfileScene.init),
                           isActive: viewStore.binding(get: { $0 != nil }, send: ProfileAction.editProfileClosed),
                           label: {})
        }
    }
    
    private var topControls: some View {
        WithViewStore(store) { viewStore in
            
            Menu {
                Button { viewStore.send(.profileTypeChanged(.student)) } label: {
                    Text(Localizable.student)
                }
                Button { viewStore.send(.profileTypeChanged(.teacher)) } label: {
                    Text(Localizable.teacher)
                }
            } label: {
                HStack {
                    Text(viewStore.profileType.title)
                    Image(systemName: "chevron.down")
                }
                .font(.body)
                .padding(.vertical, .spacing(.small))
                .padding(.horizontal)
                .bubbled()
            }
            
            Picker("", selection: viewStore.binding(get: \.selectedTab.rawValue, send: { .changeSelectedTab($0) })) {
                ForEach(viewStore.profileType.tabs) { tab in
                    Text(tab.title)
                        .tag(tab.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, .spacing(.big))
        }
    }
    
    private var tabContent: some View {
        WithViewStore(store.scope(state: \.selectedTab)) { viewStore in
            switch viewStore.state {
            case .settings:
                Text("Settings")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .bubbled()
                    .padding()
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                
            case .teacher:
                TeacherInfoView(store: store.scope(state: \.teacherInfoState, action: ProfileAction.teacherInfo))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .students:
                EmptyView()
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(store: .init(initialState: .init(userID: .init()), reducer: .empty, environment: ()))
    }
}
