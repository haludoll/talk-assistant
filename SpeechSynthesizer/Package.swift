// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpeechSynthesizer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SpeechSynthesizer",
            targets: ["SpeechSynthesizer"]),
    ],
    targets: [
        .target(
            name: "SpeechSynthesizer"),
        .testTarget(
            name: "SpeechSynthesizerTests",
            dependencies: ["SpeechSynthesizer"]),
    ]
)
