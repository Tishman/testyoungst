//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 02.05.2021.
//

import SwiftUI
import ComposableArchitecture

struct ProfileScene: View {
    
    let store: Store<ProfileState, ProfileAction>
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScene(store: .init(initialState: .init(userID: .init()), reducer: .empty, environment: ()))
    }
}
