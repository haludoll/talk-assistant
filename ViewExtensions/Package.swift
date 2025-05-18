// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ViewExtensions",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ViewExtensions",
            targets: ["ViewExtensions"]),
    ],
    targets: [
        .target(
            name: "ViewExtensions"),
    ]
)
