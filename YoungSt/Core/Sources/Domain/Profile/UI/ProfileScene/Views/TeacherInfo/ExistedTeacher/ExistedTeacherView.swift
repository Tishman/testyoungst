//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//


import SwiftUI
import ComposableArchitecture
import Resources
import Utilities

struct ExistedTeacherView: View {
    
    let store: Store<TeacherInfoExistsState, ExistedTeacherAction>
    
    var body: some View {
        VStack {
            WithViewStore(store) { viewStore in
                ProfileInfoView(profileInfo: viewStore.profile,
                                subtitle: "",
                                showChevron: false)
                
                Button { viewStore.send(.removeTeacher) } label: {
                    Text(Localizable.removeTeacher)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
