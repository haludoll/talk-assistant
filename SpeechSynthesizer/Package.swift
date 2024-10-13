// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpeechSynthesizer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "SpeechSynthesizer", targets: ["SpeechSynthesizer"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SpeechSynthesizer",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ]
        ),
        .testTarget(name: "SpeechSynthesizerTests", dependencies: ["SpeechSynthesizer"]),
    ]
)
