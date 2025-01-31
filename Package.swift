// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VersionChecker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "VersionChecker",
            targets: ["VersionChecker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Infomaniak/ios-core", .upToNextMajor(from: "14.0.0"))
    ],
    targets: [
        .target(
            name: "VersionChecker",
            dependencies: [
                .product(name: "InfomaniakCore", package: "ios-core")
            ]
        ),
        .testTarget(
            name: "VersionCheckerTests",
            dependencies: ["VersionChecker"]
        ),
    ]
)
