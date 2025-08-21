// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VersionChecker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "VersionChecker",
            targets: ["VersionChecker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Infomaniak/ios-core", .upToNextMajor(from: "16.0.0")),
        .package(url: "https://github.com/Infomaniak/ios-core-ui", .upToNextMajor(from: "21.0.0"))
    ],
    targets: [
        .target(
            name: "VersionChecker",
            dependencies: [
                .product(name: "InfomaniakCore", package: "ios-core"),
                .product(name: "InfomaniakCoreSwiftUI", package: "ios-core-ui")
            ]
        ),
        .testTarget(
            name: "VersionCheckerTests",
            dependencies: ["VersionChecker"]
        ),
    ]
)
