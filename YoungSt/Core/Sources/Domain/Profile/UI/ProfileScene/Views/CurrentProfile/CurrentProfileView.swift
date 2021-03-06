//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 13.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct CurrentProfileView: View {
    
    let store: Store<CurrentProfileState, CurrentProfileAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: .spacing(.regular)) {
                ProfileAvatarView(source: viewStore.avatarSource, size: .big)
                
                switch viewStore.infoState {
                case .loading:
                    IndicatorView()
                case .infoRequired:
                    VStack(spacing: .spacing(.small)) {
                        Text(Localizable.shouldFinishInfoProviding)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .font(.callout)
                        Button { viewStore.send(.editInfoOpened) } label: {
                            Text(Localizable.provideInfo)
                                .bold()
                        }
                    }
                case let .infoProvided(info):
                    Text("\(info.firstName) \(info.lastName)")
                        .font(.title2.bold())
                }
                if let nickname = viewStore.nickname {
                    Text("@\(nickname)")
                        .foregroundColor(.secondary)
                }
            }
            .onAppear { viewStore.send(.viewAppeared) }
        }
    }
}

struct CurrentProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentProfileView(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
