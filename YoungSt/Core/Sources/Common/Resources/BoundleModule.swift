//
//  File.swift
//  
//
//  Created by Роман Тищенко on 12.03.2021.
//

import Foundation

private class CurrentBundleFinder {}

extension Foundation.Bundle {
    public static var coreModule: Bundle = {
        /* The name of your local package, prepended by "LocalPackages_" */
        let bundleNameIOS = "Core_Resources"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]
        
        for candidate in candidates {
            let bundlePathiOS = candidate?.appendingPathComponent(bundleNameIOS + ".bundle")
            guard let bundle = bundlePathiOS.flatMap(Bundle.init(url:)) else { continue }
            return bundle
        }
        fatalError("Unable to find bundle")
    }()
}
