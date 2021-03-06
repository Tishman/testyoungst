// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum CorePackage: String, CaseIterable {
    case utilities = "Utilities"
    case resources = "Resources"
    case protocols = "Protocols"
    case mocks = "Mocks"
    case networkService = "NetworkService"
    case translation = "Translation"
    case coordinator = "Coordinator"
    case authorization = "Authorization"
    case dictionaries = "Dictionaries"
    case profile = "Profile"
    
    var library: Product {
        .library(name: rawValue, targets: [rawValue])
    }
    
    var dependency: Target.Dependency {
        .byName(name: rawValue)
    }
    
    var path: String {
        switch self {
        case .protocols, .mocks:
            return "Sources/API/" + rawValue
        case .utilities, .resources, .coordinator:
            return "Sources/Common/" + rawValue
        case .networkService:
            return "Sources/Service/" + rawValue
        case .translation, .authorization, .dictionaries, .profile:
            return "Sources/Domain/" + rawValue
        }
    }
    
    var testName: String {
        rawValue + "Tests"
    }
}

enum ExternalDependecy {
    case grpc
    case diTranquillity
    case combineExpect
    case composableArchitecture
    case keychain
    case introspect
    case meshy
    
    var product: Target.Dependency {
        switch self {
        case .grpc:
            return .product(name: "GRPC", package: "grpc-swift")
        case .diTranquillity:
            return .product(name: "DITranquillity", package: "DITranquillity")
        case .combineExpect:
            return "CombineExpectations"
        case .composableArchitecture:
            return .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        case .keychain:
            return .product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper")
        case .introspect:
            return "Introspect"
        case .meshy:
            return "Meshy"
        }
    }
}

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: CorePackage.allCases.map(\.library),
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.2.0"),
        .package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "4.1.7"),
        .package(url: "https://github.com/groue/CombineExpectations.git", from: "0.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.17.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper", from: "4.0.1"),
        .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.3"),
        .package(name: "Meshy", url: "https://github.com/Nekitosss/meshy.git", from: "0.0.4"),
    ],
    targets: [
        .target(name: CorePackage.dictionaries.rawValue,
                dependencies: [
                    CorePackage.protocols.dependency,
                    CorePackage.networkService.dependency,
                    CorePackage.coordinator.dependency,
                    ExternalDependecy.diTranquillity.product,
                    ExternalDependecy.composableArchitecture.product,
                    ExternalDependecy.introspect.product,
                    ExternalDependecy.meshy.product,
                ],
                path: CorePackage.dictionaries.path),
        .target(name: CorePackage.profile.rawValue,
                dependencies: [
                    CorePackage.protocols.dependency,
                    CorePackage.networkService.dependency,
                    CorePackage.coordinator.dependency,
                    ExternalDependecy.diTranquillity.product,
                    ExternalDependecy.composableArchitecture.product,
                    ExternalDependecy.introspect.product,
                ],
                path: CorePackage.profile.path),
        .target(name: CorePackage.coordinator.rawValue,
                dependencies: [
                    CorePackage.protocols.dependency,
                    CorePackage.utilities.dependency,
                    ExternalDependecy.diTranquillity.product
                ],
                path: CorePackage.coordinator.path),
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
                CorePackage.utilities.dependency,
                CorePackage.resources.dependency,
                ExternalDependecy.grpc.product,
                ExternalDependecy.diTranquillity.product
            ],
            path: CorePackage.networkService.path
        ),
        .testTarget(name: CorePackage.networkService.testName,
                    dependencies: [
                        CorePackage.networkService.dependency,
                        ExternalDependecy.grpc.product,
                        ExternalDependecy.diTranquillity.product,
                        ExternalDependecy.combineExpect.product,
                    ]),
        .target(
            name: CorePackage.resources.rawValue,
            path: CorePackage.resources.path,
            resources: [.copy("Sources/Common/Resources")]
        ),
        .target(
            name: CorePackage.utilities.rawValue,
            dependencies: [CorePackage.resources.dependency,
                           CorePackage.protocols.dependency,
                           ExternalDependecy.introspect.product,
                           ExternalDependecy.composableArchitecture.product,
            ],
            path: CorePackage.utilities.path
        ),
        .testTarget(name: CorePackage.utilities.testName,
                    dependencies: [
                        CorePackage.utilities.dependency,
                    ]),
        .target(
            name: CorePackage.translation.rawValue,
            dependencies: [
                CorePackage.protocols.dependency,
                CorePackage.networkService.dependency,
                CorePackage.coordinator.dependency,
                ExternalDependecy.diTranquillity.product,
                ExternalDependecy.composableArchitecture.product,
                ExternalDependecy.introspect.product,
            ],
            path: CorePackage.translation.path
        ),
        .target(
            name: CorePackage.authorization.rawValue,
            dependencies: [
                CorePackage.resources.dependency,
                ExternalDependecy.composableArchitecture.product,
                ExternalDependecy.grpc.product,
                ExternalDependecy.keychain.product,
                CorePackage.networkService.dependency,
                CorePackage.utilities.dependency,
                CorePackage.coordinator.dependency
            ],
            path: CorePackage.authorization.path,
            resources: [.copy("Sources/Common/Resources")]
        )
    ]
)

