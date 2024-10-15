// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Root",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Root",
            targets: ["Root"])
    ],
    dependencies: [
        .package(name: "Conversation", path: "../Conversation"),
        .package(name: "Settings", path: "../Settings"),
    ],
    targets: [
        .target(
            name: "Root",
            dependencies: [
                .product(name: "ConversationPresentation", package: "Conversation"),
                .product(name: "SettingsPresentation", package: "Settings")
            ]
        ),
        .testTarget(
            name: "RootTests",
            dependencies: ["Root"]
        ),
    ]
)
