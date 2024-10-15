// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Settings",
    products: [
        .library(
            name: "SettingsPresentation",
            targets: ["Presentation"]),
    ],
    targets: [
        .target(
            name: "Presentation"),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
    ]
)
