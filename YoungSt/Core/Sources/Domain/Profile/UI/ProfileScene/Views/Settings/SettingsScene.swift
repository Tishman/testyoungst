//
//  SwiftUIView.swift
//  
//
//  Created by Nikita Patskov on 14.06.2021.
//

import SwiftUI
import ComposableArchitecture
import Resources
import Utilities


struct SettingsScene: View {
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                if UIApplication.shared.supportsAlternateIcons {
                    Section(header: Text(Localizable.general)) {
                        NavigationLink(destination: CustomIconSelectorView()) {
                            Label(Localizable.changeAppIcon, systemImage: "app")
                                .labelStyle(SettingsLabelStyle(imageBackground: .purple))
                        }
                    }
                }
                
                Section(header: Text(Localizable.feedback)) {
                    Link(destination: twitterAppPageURL) {
                        Label(Localizable.requestSupport, systemImage: "ant.fill")
                            .labelStyle(SettingsLabelStyle(imageBackground: .green))
                    }
                    Button { viewStore.send(.route(.mail)) } label: {
                        Label(Localizable.sendFeedbackViaMail, systemImage: "envelope.fill")
                            .labelStyle(SettingsLabelStyle(imageBackground: .blue))
                    }
                    Link(destination: rateAppURL) {
                        Label(Localizable.rateApp, systemImage: "star.fill")
                            .labelStyle(SettingsLabelStyle(imageBackground: .yellow))
                    }
                }
                
                Button {
                    viewStore.send(.logoutTriggered)
                } label: {
                    Text(Localizable.logoutButtonTitle)
                }
                
                Section(header: Text(Localizable.info)) {
                    HStack {
                        Label(Localizable.appVersion, systemImage: "info")
                            .font(.body.bold())
                            .labelStyle(SettingsLabelStyle(imageBackground: .blue))
                        Spacer()
                        Text(Self.versionInfo)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Localizable.settings)
        .alert(store.scope(state: \.alert), dismiss: .alertClosedTriggered)
    }
    
    private let rateAppURL = URL(string: "https://apps.apple.com/app/id1570016815?action=write-review")!
    private let twitterAppPageURL = URL(string: "https://twitter.com/youngstapp")!
    
    static var versionInfo: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        return "\(appVersion) (\(buildVersion))"
    }
}

private struct SettingsLabelStyle: LabelStyle {
    
    let imageBackground: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: .spacing(.medium)) {
            configuration.icon
                .foregroundColor(.white)
                .frame(width: UIFloat(24), height: UIFloat(24))
                .padding(.spacing(.ultraSmall))
                .background(
                    RoundedRectangle(cornerRadius: .corner(.small))
                        .foregroundColor(imageBackground)
                )
            
            configuration.title
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, .spacing(.ultraSmall))
    }
    
}
