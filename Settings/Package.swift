// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Settings",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SettingsPresentation",
            targets: ["SettingsPresentation"]),
        .library(
            name: "SettingsViewModel",
            targets: ["SettingsViewModel"]),
    ],
    dependencies: [
        .package(name: "SpeechSynthesizer", path: "../SpeechSynthesizer"),
        .package(name: "ViewExtensions", path: "../ViewExtensions"),
        .package(url: "https://github.com/cybozu/LicenseList.git", from: "2.0.1")
    ],
    targets: [
        .target(
            name: "SettingsPresentation",
            dependencies: [
                "SettingsViewModel",
                .product(name: "SpeechSynthesizerDependency", package: "SpeechSynthesizer"),
                .product(name: "ViewExtensions", package: "ViewExtensions"),
                .product(name: "LicenseList", package: "LicenseList")
            ],
            path: "Sources/Presentation"
        ),
        .target(
            name: "SettingsViewModel",
            dependencies: [
                .product(name: "SpeechSynthesizerDependency", package: "SpeechSynthesizer"),
                .product(name: "SpeechSynthesizerEntity", package: "SpeechSynthesizer")
            ],
            path: "Sources/ViewModel"
        ),
        .testTarget(
            name: "SettingsPresentationTests",
            dependencies: ["SettingsPresentation"],
            path: "Tests/PresentationTests"
        ),
        .testTarget(
            name: "SettingsViewModelTests",
            dependencies: ["SettingsViewModel"],
            path: "Tests/ViewModelTests"
        ),
    ]
)
