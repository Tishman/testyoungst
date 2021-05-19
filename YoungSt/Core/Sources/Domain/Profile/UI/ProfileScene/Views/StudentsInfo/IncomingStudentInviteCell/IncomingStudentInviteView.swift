//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 16.05.2021.
//

import SwiftUI
import ComposableArchitecture
import Utilities
import Resources

struct IncomingStudentInviteView: View {
    
    let store: Store<IncomingStudentInviteState, IncomingStudentInviteAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text(viewStore.title)
                    .font(.title3)
                
                HStack {
                    Spacer()
                    
                    Button { viewStore.send(.acceptInvite) } label: {
                        Text(Localizable.acceptInvite)
                    }
                    
                    Button { viewStore.send(.rejectInvite) } label: {
                        Text(Localizable.rejectInvite)
                    }
                }
                .buttonStyle(InaccentButtonStyle())
            }
            .padding()
            .bubbled()
        }
    }
}

struct IncomingStudentInviteView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingStudentInviteView(store: .init(initialState: .preview, reducer: .empty, environment: ()))
    }
}
