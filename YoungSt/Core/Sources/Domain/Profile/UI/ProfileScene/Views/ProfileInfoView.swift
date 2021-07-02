//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.05.2021.
//

import Foundation
import SwiftUI
import Utilities

extension ProfileInfoView {
    init(profileInfo: ProfileInfo, subtitle: String, showChevron: Bool) {
        self.init(avatarSource: .init(profileInfo: profileInfo),
                  displayName: profileInfo.primaryField,
                  secondaryDisplayName: profileInfo.secondaryField,
                  subtitle: subtitle.isEmpty ? profileInfo.tertiaryField : subtitle,
                  showChevron: showChevron)
    }
}

struct ProfileInfoView: View {
    
    let avatarSource: ProfileAvatarSource
    let displayName: String
    let secondaryDisplayName: String
    let subtitle: String
    let showChevron: Bool
    
    private let chevronSize = UIFloat(16)
    
    var body: some View {
        HStack(alignment: .top, spacing: .spacing(.medium)) {
            ProfileAvatarView(source: avatarSource, size: .medium)
            
            VStack(alignment: .leading, spacing: .spacing(.medium)) {
                VStack(alignment: .leading, spacing: .spacing(.ultraSmall)) {
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
            
            if showChevron {
                Spacer()
                Image(systemName: "chevron.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.secondary)
                    .frame(width: chevronSize, height: chevronSize)
                    .frame(maxHeight: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .bubbled()
    }
    
}
