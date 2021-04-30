//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import Resources

struct DictWordView: View {
    
    let state: DictWordState
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.small)) {
            Text(state.info)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text(state.text)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .bubbled()
    }
}

struct DictWordView_Previews: PreviewProvider {
    static var previews: some View {
        DictWordView(state: .preview)
    }
}
