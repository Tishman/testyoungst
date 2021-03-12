// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum CorePackage: String, CaseIterable {
    case utilities = "Utilities"
    case resources = "Resources"
    case models = "Models"
    case protocols = "Protocols"
    case mocks = "Mocks"
    case networkService = "NetworkService"
    
    var library: Product {
        .library(name: rawValue, targets: [rawValue])
    }
    
    var dependency: Target.Dependency {
        .byName(name: rawValue)
    }
    
    var path: String {
        switch self {
        case .protocols, .models, .mocks:
            return "Sources/API/" + rawValue
        case .utilities, .resources:
            return "Sources/Common/" + rawValue
        case .networkService:
            return "Sources/Service/" + rawValue
        }
    }
    
    var testName: String {
        rawValue + "Test"
    }
}

enum ExternalDependecy {
    // Added for example
    case grdb
    
    var product: Target.Dependency {
        switch self {
        case .grdb:
            return .product(name: "GRDB", package: "GRDB")
        }
    }
}

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: CorePackage.allCases.map(\.library),
    dependencies: [],
    targets: [
        .target(
            name: CorePackage.models.rawValue,
            path: CorePackage.models.path
        ),
        .target(
            name: CorePackage.protocols.rawValue,
            path: CorePackage.protocols.path
        ),
        .target(
            name: CorePackage.mocks.rawValue,
            path: CorePackage.mocks.path
        ),
        .target(
            name: CorePackage.networkService.rawValue,
            dependencies: [CorePackage.protocols.dependency],
            path: CorePackage.networkService.path
        ),
        .target(
            name: CorePackage.resources.rawValue,
            path: CorePackage.resources.path
        ),
        .target(
            name: CorePackage.utilities.rawValue,
            path: CorePackage.utilities.path
        ),
    ]
)

