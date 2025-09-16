// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LocalStorage",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LocalStorage",
            type: .dynamic,
            targets: ["LocalStorage"]),
        .library(
            name: "ConversationPersistenceModel",
            targets: ["ConversationPersistenceModel"]),
    ],
    dependencies: [
        .package(name: "Conversation", path: "../Conversation"),
    ],
    targets: [
        .target(
            name: "ConversationPersistenceModel"
        ),
        .target(
            name: "LocalStorage",
            dependencies: [
                .product(name: "ConversationEntity", package: "Conversation")
            ])
    ]
)
