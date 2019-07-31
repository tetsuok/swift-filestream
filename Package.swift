// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileStream",
    products: [
        .library(
            name: "FileStream",
            targets: ["FileStream"]),
    ],
    targets: [
        .target(
            name: "FileStream"),
        .testTarget(
            name: "FileStreamTests",
            dependencies: ["FileStream"]),
    ]
)
