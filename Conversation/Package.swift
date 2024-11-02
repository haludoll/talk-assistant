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
        .library(
            name: "ConversationViewModel",
            targets: ["ConversationViewModel"]),
    ],
    dependencies: [
        .package(name: "SpeechSynthesizer", path: "../SpeechSynthesizer"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.4.0")
    ],
    targets: [
        .target(
            name: "ConversationPresentation",
            dependencies: ["ConversationViewModel"],
            path: "Sources/Presentation"
        ),
        .target(
            name: "ConversationViewModel",
            dependencies: [
                .product(name: "SpeechSynthesizerEntity", package: "SpeechSynthesizer"),
                .product(name: "SpeechSynthesizerDependency", package: "SpeechSynthesizer"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/ViewModel"
        ),
        .testTarget(
            name: "ConversationViewModelTests",
            dependencies: ["ConversationViewModel"],
            path: "Tests/ViewModelTests"
        )
    ]
)
