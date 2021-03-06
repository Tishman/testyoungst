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
                return UIFloat(120)
            case .medium:
                return UIFloat(150)
            case .big:
                return UIFloat(180)
            }
        }
        
        var titleFont: Font {
            switch self {
            case .small:
                return .body
            case .medium:
                return .title3
            case .big:
                return .title3
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
                .font(size.titleFont)
            
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
                    LinearGradient(gradient: YoungstGradient(id).swiftUI, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
    }
}

struct DictGroupView_Previews: PreviewProvider {
    static var previews: some View {
        DictGroupView(id: .init(), size: .medium, state: .preview)
    }
}
