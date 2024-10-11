// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Conversation",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ConversationPresentation",
            targets: ["Presentation"]),
    ],
    targets: [
        .target(
            name: "Presentation"),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
    ]
)
