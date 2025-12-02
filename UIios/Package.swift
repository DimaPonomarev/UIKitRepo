// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EupUiKit",
    platforms: [.iOS("15.0")],
    products: [
        .library(
            name: "EupUiKit",
            targets: [
                "EupUiKit",
                "SharedApi"
            ]
        )
    ],
    targets: [
        .target(
            name: "EupUiKit",
            path: "Sources/EupUiKit",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "EupUiKitTests",
            dependencies: ["EupUiKit"],
            path: "Tests/EupUiKitTests"
        ),
        .binaryTarget(
            name: "SharedApi",
            url: "https://github.com/DimaPonomarev/-eup-uikit-binaries/releases/download/v1.0.12/SharedApi.xcframework.zip" ,
            checksum: "ce0bfcda59fc3d19dea38b77e56eaf45086fe12773b8007eabeb903b65e9c2db"
        )
    ]
)
