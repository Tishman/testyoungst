//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import Utilities

struct DictGroupView: View {
    
    let state: DictGroupState
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(state.title)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .font(.title3)
            
            Spacer()
            
            Text(state.subtitle)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
                .font(.caption)
        }
        .padding()
        .foregroundColor(.white)
        .frame(minWidth: 120, maxWidth: 150, minHeight: 120, maxHeight: 150)
        .background(
            RoundedRectangle(cornerRadius: .corner(.ultraBig))
                .foregroundColor(.blue)
        )

    }
}

struct DictGroupView_Previews: PreviewProvider {
    static var previews: some View {
        DictGroupView(state: .preview)
    }
}
