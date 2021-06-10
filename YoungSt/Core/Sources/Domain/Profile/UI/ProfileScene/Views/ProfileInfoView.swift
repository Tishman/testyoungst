//
//  File.swift
//  
//
//  Created by Nikita Patskov on 17.05.2021.
//

import Foundation
import SwiftUI
import Utilities

struct ProfileInfoView: View {
    
    let avatarSource: ProfileAvatarSource
    let displayName: String
    let secondaryDisplayName: String
    let subtitle: String
    let showChevron: Bool
    
    private let chevronSize = UIFloat(16)
    
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
            
            if showChevron {
                Spacer()
                Image(systemName: "chevron.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.secondary)
                    .frame(width: chevronSize, height: chevronSize)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .bubbled()
    }
    
}
