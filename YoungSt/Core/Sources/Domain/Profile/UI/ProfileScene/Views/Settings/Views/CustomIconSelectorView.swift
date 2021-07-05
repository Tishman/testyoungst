//
//  File.swift
//  
//
//  Created by Nikita Patskov on 04.07.2021.
//

import SwiftUI
import UIKit
import Utilities

enum CustomIcon: String, CaseIterable, Identifiable {
    case `default` = "Icon-default"
    case social = "Icon-social"
    case outlined = "Icon-outlined"
    case nature = "Icon-nature"
    case boring = "Icon-boring"
    case bold = "Icon-bold"
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .default: return "Default"
        case .social: return "Social"
        case .outlined: return "Outlined"
        case .nature: return "Nature"
        case .boring: return "Boring"
        case .bold: return "Bold"
        }
    }
}

struct CustomIconSelectorView: View {
    
    var body: some View {
        List {
            ForEach(CustomIcon.allCases) { customIcon in
                Button {
                    UIApplication.shared.setAlternateIconName(customIcon.rawValue, completionHandler: nil)
                } label: {
                    HStack(spacing: .spacing(.regular)) {
                        Image(uiImage: UIImage(named: "\(customIcon.rawValue)@2x")!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: UIFloat(50), height: UIFloat(50))
                            .clipShape(imageShape)
                            .overlay(
                                imageShape
                                    .stroke(Color.black.opacity(0.33), style: .init(lineWidth: 1))
                            )
                        
                        Text(customIcon.title)
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, .spacing(.ultraSmall))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var imageShape: some Shape {
        RoundedRectangle(cornerRadius: .corner(.small), style: .continuous)
    }
}
