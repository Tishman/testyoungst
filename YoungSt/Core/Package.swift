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
    case translateScene = "TranslateScene"
    case coordinator = "Coordinator"
    case loginScene = "LoginScene"
    
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
        case .utilities, .resources, .coordinator:
            return "Sources/Common/" + rawValue
        case .networkService:
            return "Sources/Service/" + rawValue
        case .translateScene:
            return "Sources/Domain/" + rawValue
        case .loginScene:
            return "Sources/Domain/Authorization/" + rawValue
        }
    }
    
    var testName: String {
        rawValue + "Tests"
    }
}

enum ExternalDependecy {
    // Added for example
    case grdb
    case grpc
    case diTranquillity
    case combineExpect
    case composableArchitecture
    
    var product: Target.Dependency {
        switch self {
        case .grdb:
            return .product(name: "GRDB", package: "GRDB")
        case .grpc:
            return .product(name: "GRPC", package: "grpc-swift")
        case .diTranquillity:
            return .product(name: "DITranquillity", package: "DITranquillity")
        case .combineExpect:
            return "CombineExpectations"
        case .composableArchitecture:
            return .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        }
    }
}

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: CorePackage.allCases.map(\.library),
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "4.1.7"),
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.17.0")
    ],
    targets: [
        .target(name: CorePackage.coordinator.rawValue,
                path: CorePackage.coordinator.path),
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
            dependencies: [
                CorePackage.protocols.dependency,
                CorePackage.models.dependency,
                CorePackage.utilities.dependency,
                ExternalDependecy.grpc.product,
                ExternalDependecy.diTranquillity.product
            ],
            path: CorePackage.networkService.path
        ),
        .testTarget(name: CorePackage.networkService.testName,
                    dependencies: [
                        CorePackage.networkService.dependency,
                        CorePackage.models.dependency,
                        ExternalDependecy.grpc.product,
                        ExternalDependecy.diTranquillity.product,
                        ExternalDependecy.combineExpect.product,
                    ]),
        .target(
            name: CorePackage.resources.rawValue,
            path: CorePackage.resources.path
        ),
        .target(
            name: CorePackage.utilities.rawValue,
            path: CorePackage.utilities.path
        ),
        .testTarget(name: CorePackage.utilities.testName,
                    dependencies: [
                        CorePackage.utilities.dependency,
                    ]),
        .target(
            name: CorePackage.translateScene.rawValue,
            dependencies: [
                CorePackage.networkService.dependency,
                ExternalDependecy.composableArchitecture.product,
                CorePackage.resources.dependency,
                CorePackage.utilities.dependency
            ],
            path: CorePackage.translateScene.path
        ),
        .target(
            name: CorePackage.loginScene.rawValue,
            dependencies: [
                ExternalDependecy.composableArchitecture.product,
                CorePackage.networkService.dependency,
                CorePackage.resources.dependency,
                CorePackage.utilities.dependency
            ],
            path: CorePackage.loginScene.path
            )
    ]
)

