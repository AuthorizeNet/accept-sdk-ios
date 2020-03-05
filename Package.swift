// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AcceptSDK",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "AcceptSDK",
            targets: ["AcceptSDK"]
        ),
    ],
    targets: [
        .target(
            name: "AcceptSDK",
            path: "AcceptSDK"
        ),
        .testTarget(
            name: "AcceptSDKTests",
            dependencies: ["AcceptSDK"],
            path: "AcceptSDKTests"
        ),
    ]
)
