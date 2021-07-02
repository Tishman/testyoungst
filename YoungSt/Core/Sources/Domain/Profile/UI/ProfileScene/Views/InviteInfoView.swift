//
//  File.swift
//  
//
//  Created by Nikita Patskov on 22.06.2021.
//

import SwiftUI
import Resources
import Utilities

struct InviteInfoView: View {
    
    let avatarSource: ProfileAvatarSource
    let displayName: String
    let secondaryDisplayName: String
    let subtitle: String
    let accept: (() -> Void)?
    let reject: () -> Void
    
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
                
                HStack {
                    Spacer()
                    if let accept = accept {
                        Button(action: accept) {
                            Text(Localizable.acceptInvite)
                        }
                    }
                    
                    Button(action: reject) {
                        Text(Localizable.rejectInvite)
                    }
                }
                .buttonStyle(PlainInaccentButtonStyle())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .bubbled()
    }
    
}
