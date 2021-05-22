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
    
    @Environment(\.coordinator) private var coordinator
    
    var body: some View {
        GeometryReader { globalProxy in
            WithViewStore(store) { viewStore in
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
                .onAppear { viewStore.send(.viewAppeared) }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if viewStore.currentProfileState.isInfoProvided {
                            Button { viewStore.send(.changeDetail(.editProfile)) } label: {
                                Image(systemName: "pencil.circle")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button { viewStore.send(.changeDetail(.shareProfile)) } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        .fixNavigationLinkForIOS14_5()
        .background(detailNavigationLink)
        .makeCustomBarManagement(offset: contentOffset, topHidden: $dividerHidden)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var detailNavigationLink: some View {
        WithViewStore(store.scope(state: \.detailState)) { viewStore in
            NavigationLink(destination: linkDetailDestination,
                           isActive: viewStore.binding(get: { $0 != nil }, send: .changeDetail(.closed)),
                           label: {})
                .isDetailLink(false)
        }
    }
    
    private var linkDetailDestination: some View {
        WithViewStore(store.scope(state: \.detailState)) { viewStore in
            switch viewStore.state {
            case .shareProfile:
                IfLetStore(store.scope(state: \.shareProfileState, action: ProfileAction.shareProfile),
                                                       then: ShareProfileScene.init)
            case .fillInfo:
                IfLetStore(store.scope(state: \.fillInfoState, action: ProfileAction.fillProfileInfo),
                                                       then: FinishProfileUpdatingScene.init)
                
            case .editProfile:
                IfLetStore(store.scope(state: \.editProfileState, action: ProfileAction.editProfile),
                                                       then: EditProfileScene.init)
                
            case let .openedStudent(id):
                coordinator.view(for: .dictionaries(.init(userID: id)))
                    .id(id)
                
            case .none:
                EmptyView()
            }
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
                Button {
                    viewStore.send(.logout)
                } label: {
                    Text("Logout")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .bubbled()
                .padding()
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                
            case .teacher:
                TeacherInfoView(store: store.scope(state: \.teacherInfoState, action: ProfileAction.teacherInfo))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .students:
                StudentsInfoView(store: store.scope(state: \.studentsInfoState, action: ProfileAction.studentsInfo))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
    }
    
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(store: .init(initialState: .init(userID: .init()), reducer: .empty, environment: ()))
    }
}
