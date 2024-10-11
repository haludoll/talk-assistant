// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Root",
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
                .product(name: "ConversationPresentation", package: "Conversation", moduleAliases: ["Presentation" : "ConversationPresentation"]),
                .product(name: "SettingsPresentation", package: "Settings", moduleAliases: ["Presentation" : "SettingsPresentation"])
            ]
        ),
        .testTarget(
            name: "RootTests",
            dependencies: ["Root"]
        ),
    ]
)
