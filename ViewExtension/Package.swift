// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ViewExtension",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ViewExtension",
            targets: ["ViewExtension"]),
    ],
    targets: [
        .target(
            name: "ViewExtension"),
    ]
)
