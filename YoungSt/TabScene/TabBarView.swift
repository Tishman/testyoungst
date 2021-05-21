//
//  TabBarView.swift
//  YoungSt
//
//  Created by Nikita Patskov on 03.05.2021.
//

import SwiftUI
import Resources

struct TabItem {
    enum Identifier: Int, Hashable {
        case dictionaries
        case profile
        
        var title: String {
            switch self {
            case .dictionaries:
                return Localizable.dictionaries
            case .profile:
                return Localizable.profile
            }
        }
        
        var imageName: String {
            switch self {
            case .dictionaries:
                return "rectangle.stack"
            case .profile:
                return "person.circle"
            }
        }
    }
    
    let id: Identifier
    
    var title: String { id.title }
    var imageName: String { id.imageName }
    
    var accentImageName: String {
        switch id {
        case .dictionaries:
            return "rectangle.stack.fill"
        case .profile:
            return "person.circle.fill"
        }
    }
    
    let selectHandler: () -> Void
}

struct TabBarView: View {
    
    let leftItem: TabItem
    let rightItem: TabItem
    let selectedTab: TabItem.Identifier
    
    let mainButtonHandler: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Spacer()
                itemView(for: leftItem)
                Spacer()
                Spacer()
                mainButton
                Spacer()
                Spacer()
                itemView(for: rightItem)
                Spacer()
            }
            .padding(.vertical, .spacing(.small))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func itemView(for item: TabItem) -> some View {
        Button(action: item.selectHandler) {
            VStack {
                Image(systemName: item.id == selectedTab ? item.accentImageName : item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
                Text(item.title)
                    .font(.system(size: 12)) // should not scale
            }
        }
        .foregroundColor(item.id == selectedTab ? Asset.Colors.greenDark.color.swiftuiColor : Color(UIColor.systemGray2))
        .frame(maxWidth: .infinity)
    }
    
    private var mainButton: some View {
        Button(action: mainButtonHandler) {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(15)
                .background(Asset.Colors.greenDark.color.swiftuiColor)
                .clipShape(RoundedRectangle(cornerRadius: .corner(.ultraBig)))
        }
        .accentColor(.white)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(leftItem: .init(id: .dictionaries, selectHandler: {}),
                   rightItem: .init(id: .profile, selectHandler: {}),
                   selectedTab: .dictionaries,
                   mainButtonHandler: {})
    }
}
