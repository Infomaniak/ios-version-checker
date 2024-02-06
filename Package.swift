// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VersionChecker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VersionChecker",
            targets: ["VersionChecker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Infomaniak/ios-core", .upToNextMajor(from: "6.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
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
