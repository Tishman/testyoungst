//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.05.2021.
//

import Foundation
import SwiftUI
import Utilities

enum ProfileAvatarSource: Equatable {
    case info(id: UUID, title: String)
    // TODO: Add remote url
    
    init(profileInfo: ProfileInfo) {
        var title: String = ""
        let components = profileInfo.primaryField.split(maxSplits: 2, omittingEmptySubsequences: true, whereSeparator: { $0 == " " })
        if !components.isEmpty {
            title = "\(components[0].first!)"
        }
        if components.count > 1 {
            title += "\(components[1].first!)"
        }
        
        self = .info(id: profileInfo.id, title: title.uppercased())
    }
    
    init(id: UUID, title: String) {
        let aTitle = title.isEmpty ? "" : "\(title.first!)".uppercased()
        self = .info(id: id, title: aTitle)
    }
    
    init(id: UUID, first: String, last: String) {
        let title: String
        if !first.isEmpty {
            if !last.isEmpty {
                title = "\(first.first!)\(last.first!)"
            } else {
                title = "\(first.first!)"
            }
        } else if !last.isEmpty {
            title = "\(last.first!)"
        } else {
            title = ""
        }
        self = .info(id: id, title: title.uppercased())
    }
}

struct ProfileAvatarView: View {
    
    enum Size: CaseIterable {
        case medium
        case big
        
        var value: CGFloat {
            switch self {
            case .medium:
                return UIFloat(60)
            case .big:
                return UIFloat(120)
            }
        }
        
        var titleFont: Font {
            switch self {
            case .medium:
                return .system(size: 24, weight: .semibold, design: .rounded)
            case .big:
                return .system(size: 34, weight: .bold, design: .rounded)
            }
        }
        
        var corner: CGFloat {
            switch self {
            case .medium:
                return .corner(.small)
            case .big:
                return .corner(.medium)
            }
        }
    }
    
    let source: ProfileAvatarSource
    let size: Size
    
    var body: some View {
        switch source {
        case let .info(id, title):
            Text(title)
                .font(size.titleFont)
                .foregroundColor(.white)
                .frame(width: size.value, height: size.value)
                .background(
                    RoundedRectangle(cornerRadius: size.corner)
                        .fill(
                            LinearGradient(gradient: YoungstGradient(id).swiftUI, startPoint: .bottom, endPoint: .top)
                        )
                )
            
        }
    }
}


struct ProfileAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ProfileAvatarView.Size.allCases, id: \.self) {
            ProfileAvatarView(source: .info(id: .init(), title: "MR"), size: $0)
        }
    }
}
