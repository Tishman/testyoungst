//
//  YoungStApp.swift
//  YoungSt
//
//  Created by tichenko.r on 22.12.2020.
//

import SwiftUI
import ComposableArchitecture
import GRDB
import NetworkService
import DITranquillity
import Coordinator
import Authorization
import Utilities
import Resources

struct Test: View {
    @Namespace private var animation
    @State private var flag: Bool = true
    private let editAnimationID = "EditAnimation"
    private let editAnimation = Animation.spring(response: 0.45, dampingFraction: 0.6)
    
    var body: some View {
        HStack(spacing: .spacing(.ultraBig)) {
            HStack {
                if flag {
                    Button {
                        withAnimation(editAnimation) {
                            flag.toggle()
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
                    .matchedGeometryEffect(id: editAnimationID, in: animation, anchor: .leading)
                    
                } else {
                    HStack {
                        TextField("Test", text: .constant(""))
                            .frame(minHeight: InaccentButtonStyle.defaultSize)
                        Button {
                            withAnimation(editAnimation) {
                                flag.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: InaccentButtonStyle.defaultSize, height: InaccentButtonStyle.defaultSize)
                        }
                    }
                    .padding(.vertical, .spacing(.medium) + .spacing(.ultraSmall))
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: editAnimationID, in: animation, anchor: .leading)
                }
            }
            .bubbled()
            .padding(.horizontal, flag ? 0 : .spacing(.regular))
            
            if flag {
                Button {  } label: {
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
    }
}

@main
struct YoungStApp: App {
    private let container: DIContainer
    private let coordinator: Coordinator
    
    let store: Store<AppState, AppAction>
    
    init() {
        let container = ApplicationDI.container
        
        self.container = container
        self.coordinator = container.resolve()
        self.store = .init(initialState: .init(),
                           reducer: appReducer,
                           environment: container.resolve())
    }
    
    var body: some Scene {
        WindowGroup {
//            Test()
            AppScene.init(coordinator: coordinator, store: store)
                .edgesIgnoringSafeArea(.all)
                .accentColor(Asset.Colors.greenDark.color.swiftuiColor)
                .environment(\.coordinator, container.resolve())
        }
    }
}

