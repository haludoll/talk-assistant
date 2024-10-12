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
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(name: "SpeechSynthesizer", path: "../SpeechSynthesizer"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [.product(name: "SpeechSynthesizer", package: "SpeechSynthesizer")]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
    ]
)
