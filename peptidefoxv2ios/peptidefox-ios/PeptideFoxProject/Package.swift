// swift-tools-version: 5.9
// Package manifest for PeptideFox test dependencies

import PackageDescription

let package = Package(
    name: "PeptideFox",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PeptideFox",
            targets: ["PeptideFox"]
        )
    ],
    dependencies: [
        // Snapshot testing for visual regression tests
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0")
    ],
    targets: [
        .target(
            name: "PeptideFox",
            dependencies: []
        ),
        .testTarget(
            name: "PeptideFoxTests",
            dependencies: [
                "PeptideFox",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
