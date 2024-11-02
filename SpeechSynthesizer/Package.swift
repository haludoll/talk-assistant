// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpeechSynthesizer",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SpeechSynthesizerDependency", targets: ["SpeechSynthesizerDependency"]),
        .library(name: "SpeechSynthesizerEntity", targets: ["SpeechSynthesizerEntity"]),
        .library(name: "SpeechSynthesizerRepository", targets: ["SpeechSynthesizerRepository"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.4.0")
    ],
    targets: [
        .target(
            name: "SpeechSynthesizerDependency",
            dependencies: [
                "SpeechSynthesizerEntity",
                "SpeechSynthesizerRepository",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/Dependency"
        ),
        .target(
            name: "SpeechSynthesizerEntity",
            dependencies: [.product(name: "AsyncAlgorithms", package: "swift-async-algorithms")],
            path: "Sources/Entity"
        ),
        .target(
            name: "SpeechSynthesizerRepository",
            dependencies: [
                "SpeechSynthesizerEntity",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/Repository"
        ),
    ]
)
