// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Conversation",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ConversationPresentation",
            targets: ["ConversationPresentation"]),
    ],
    dependencies: [
        .package(name: "SpeechSynthesizer", path: "../SpeechSynthesizer"),
    ],
    targets: [
        .target(
            name: "ConversationPresentation",
            dependencies: [.product(name: "SpeechSynthesizer", package: "SpeechSynthesizer")],
            path: "Sources/Presentation"
        ),
        .testTarget(
            name: "ConversationPresentationTests",
            dependencies: ["ConversationPresentation"],
            path: "Tests/PresentationTests"
        )
    ]
)
