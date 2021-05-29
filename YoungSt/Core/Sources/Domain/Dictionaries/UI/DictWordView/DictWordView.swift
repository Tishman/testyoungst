//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import Resources
import Utilities

struct DictWordView: View {
    
    let state: DictWordState
    private let minRowHeight: CGFloat = UIFloat(60)
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.small)) {
            if !state.info.isEmpty {
                Text(state.info)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(state.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !state.translation.isEmpty {
                    Divider()
                    Text(state.translation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: minRowHeight, alignment: .leading)
        .bubbled()
    }
}

struct DictWordView_Previews: PreviewProvider {
    static var previews: some View {
        DictWordView(state: .preview)
    }
}
