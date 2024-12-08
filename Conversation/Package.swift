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
            name: "ConversationDependency",
            targets: ["ConversationDependency"]),
        .library(
            name: "ConversationEntity",
            targets: ["ConversationEntity"]),
        .library(
            name: "ConversationPresentation",
            targets: ["ConversationPresentation"]),
        .library(
            name: "ConversationRepository",
            targets: ["ConversationRepository"]),
        .library(
            name: "ConversationViewModel",
            targets: ["ConversationViewModel"]),
    ],
    dependencies: [
        .package(name: "SpeechSynthesizer", path: "../SpeechSynthesizer"),
        .package(name: "LocalStorage", path: "../LocalStorage"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.4.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        .target( 
            name: "ConversationDependency",
            dependencies: [
                "ConversationEntity",
                "ConversationRepository",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ],
            path: "Sources/Dependency"
        ),
        .target(
            name: "ConversationEntity",
            path: "Sources/Entity"
        ),
        .target(
            name: "ConversationPresentation",
            dependencies: [
                "ConversationViewModel",
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources/Presentation"
        ),
        .target(
            name: "ConversationRepository",
            dependencies: [
                "ConversationEntity",
                .product(name: "LocalStorage", package: "LocalStorage"),
            ],
            path: "Sources/Repository"
        ),
        .target(
            name: "ConversationViewModel",
            dependencies: [
                "ConversationEntity",
                "ConversationDependency",
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
