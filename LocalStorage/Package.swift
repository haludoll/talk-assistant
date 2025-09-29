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
            name: "LocalStorageCore",
            type: .dynamic,
            targets: ["LocalStorageCore"]),
        .library(
            name: "ConversationPersistenceModel",
            targets: ["ConversationPersistenceModel"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ConversationPersistenceModel"
        ),
        .target(
            name: "LocalStorageCore",
            dependencies: [
                "ConversationPersistenceModel"
            ],
            path: "Sources/LocalStorageCore"
        )
    ]
)
