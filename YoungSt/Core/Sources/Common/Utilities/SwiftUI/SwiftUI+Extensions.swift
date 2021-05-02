//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI
import Introspect

public extension View {
    
    var erased: AnyView {
        AnyView(self)
    }
    
    func addRefreshToScrollView(handler: @escaping () -> Void) -> some View {
        self.introspectScrollView { scrollView in
            guard UIDevice.current.userInterfaceIdiom != .mac else { return }
            let refresh: UIRefreshControl
            if let existed = scrollView.refreshControl {
                refresh = existed
            } else {
                refresh = UIRefreshControl(frame: .zero, primaryAction: .init(handler: { [weak scrollView] _ in
                    handler()
                    scrollView?.refreshControl?.endRefreshing()
                }))
                scrollView.refreshControl = refresh
            }
        }
    }
}

public extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
