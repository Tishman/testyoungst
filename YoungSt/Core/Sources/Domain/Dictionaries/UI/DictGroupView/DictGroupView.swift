//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 27.04.2021.
//

import SwiftUI
import Utilities

struct DictGroupView: View {
    
    enum Size {
        case small
        case medium
        case big
        
        var value: CGFloat {
            switch self {
            case .small:
                return 130
            case .medium:
                return 150
            case .big:
                return 180
            }
        }
    }
    
    let id: UUID
    let size: Size
    let state: DictGroupState
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(state.title)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .font(.title3)
            
            Spacer()
            
            if !state.subtitle.isEmpty {
                Text(state.subtitle)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                    .font(.caption)
            }
        }
        .padding()
        .foregroundColor(.white)
        .frame(width: size.value, height: size.value)
        .background(
            RoundedRectangle(cornerRadius: .corner(.ultraBig))
                .fill(
                    LinearGradient(gradient: Gradients(id).swiftUI, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
    }
}

struct DictGroupView_Previews: PreviewProvider {
    static var previews: some View {
        DictGroupView(id: .init(), size: .medium, state: .preview)
    }
}
