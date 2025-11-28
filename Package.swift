// swift-tools-version: 6.0
// (be sure to update the .swift-version file when this Swift version changes)

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-prefs",
    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "SwiftPrefs", targets: ["SwiftPrefs"]),
        .library(name: "SwiftPrefsCore", targets: ["SwiftPrefsCore"]),
        .library(name: "SwiftPrefsUI", targets: ["SwiftPrefsUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0" ..< "99999999.999.999")
    ],
    targets: [
        .target(
            name: "SwiftPrefs",
            dependencies: ["SwiftPrefsCore", "SwiftPrefsUI"]
        ),
        .target(
            name: "SwiftPrefsCore",
            dependencies: ["SwiftPrefsTypes", "SwiftPrefsMacrosImplementation"]
        ),
        .target(
            name: "SwiftPrefsTypes",
            dependencies: []
        ),
        .macro(
            name: "SwiftPrefsMacrosImplementation",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),
        .target(
            name: "SwiftPrefsUI",
            dependencies: ["SwiftPrefsCore"]
        ),
        .testTarget(
            name: "SwiftPrefsCoreTests",
            dependencies: [
                "SwiftPrefsCore",
                "SwiftPrefsMacrosImplementation",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "SwiftPrefsTypesTests",
            dependencies: ["SwiftPrefsTypes"]
        )
    ]
)
