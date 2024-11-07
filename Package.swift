// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KakaoHealthcareUI",
    platforms: [
      .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KakaoHealthcareUI",
            targets: ["KakaoHealthcareUI"])
    ],
    dependencies: [

        .package(url: "https://github.com/kakaohealthcare-DT/KakaoHealthcareFoundation.git", branch: "main"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KakaoHealthcareUI",
            dependencies: [
                "SnapKit",
                "KakaoHealthcareFoundation"
            ]
        ),
        .testTarget(
            name: "KakaoHealthcareUITests",
            dependencies: ["KakaoHealthcareUI"]
        ),
    ]
)
