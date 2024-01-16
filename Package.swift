// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForceControls",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ForceControls",
            targets: ["LoadingButton", "LabelTextField"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LoadingButton",
            path: "Sources/LoadingButton"),
        .target(
            name: "LabelTextField",
            path: "Sources/LabelTextField"),
        .testTarget(
            name: "ForceControlsTests",
            dependencies: ["LoadingButton"]),
    ]
)
