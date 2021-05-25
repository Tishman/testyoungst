//
//  File.swift
//  
//
//  Created by Nikita Patskov on 03.04.2021.
//

import Foundation
import SwiftUI
import Introspect
import UIKit

public extension UIViewController {
    
    var erased: UIViewController { self }
    
}

public extension View {
    
    var erased: AnyView {
        AnyView(self)
    }
    
    var uiKitHosted: UIHostingController<Self> {
        .init(rootView: self)
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
    
    
    /// Due to bug in SwiftUI in iOS 14.5 we ARE NOT ALLOWED TO GAVE EXACT 2 NavigationLink.
    /// It can be 0,1 or 3+
    /// So if we can possibly have navigationlink in view, we sould add two additional links to background
    func fixNavigationLinkForIOS14_5() -> some View {
        self
            .background(NavigationLink(destination: EmptyView(), label: {}))
            .background(NavigationLink(destination: EmptyView(), label: {}))
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
