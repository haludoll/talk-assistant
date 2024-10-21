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
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.1")
    ],
    targets: [
        .target(
            name: "SpeechSynthesizer",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(name: "SpeechSynthesizerTests", dependencies: ["SpeechSynthesizer"]),
    ]
)
