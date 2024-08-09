// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlamofireAPIClient",
    platforms: [.iOS("13.0")],
    products: [
        .library(
            name: "AlamofireAPIClient",
            targets: ["AlamofireAPIClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "master"),
        .package(path: "./APIClient")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AlamofireAPIClient", dependencies: ["Alamofire", "APIClient"]),
        .testTarget(
            name: "AlamofireAPIClientTests",
            dependencies: ["AlamofireAPIClient"])
    ]
)
