//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.05.2021.
//

import Foundation
import SwiftUI

struct ProfileInfoView: View {
    
    let avatarSource: ProfileAvatarSource
    let displayName: String
    let secondaryDisplayName: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: .spacing(.medium)) {
            ProfileAvatarView(source: avatarSource, size: .medium)
            
            VStack(alignment: .leading, spacing: .spacing(.medium)) {
                VStack(alignment: .leading, spacing: .spacing(.small)) {
                    Text(displayName)
                        .font(.title3)
                    Text(secondaryDisplayName)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .bubbled()
    }
    
}
