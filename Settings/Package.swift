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
    ],
    targets: [
        .target(
            name: "SettingsPresentation",
            path: "Sources/Presentation"),
        .testTarget(
            name: "SettingsPresentationTests",
            dependencies: ["SettingsPresentation"],
            path: "Tests/PresentationTests"
        ),
    ]
)
