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
            //type: .dynamic,
            targets: ["LocalStorage"]),
    ],
    dependencies: [
        .package(name: "Conversation", path: "../Conversation"),
    ],
    targets: [
        .target(
            name: "LocalStorage",
            dependencies: [.product(name: "ConversationEntity", package: "Conversation")])
    ]
)
