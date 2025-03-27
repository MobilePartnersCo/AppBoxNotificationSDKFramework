// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppBoxNotificationSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AppBoxNotificationSDK",
            targets: ["AppBoxNotificationSDK"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            "11.0.0" ..< "12.0.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "AppBoxCore",
            path: "./Sources/AppBoxCore/AppBoxCore.xcframework"
        ),
        .target(
            name: "AppBoxNotificationSDK",
            dependencies: [
                "AppBoxCore",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: "Sources/AppBoxNotificationSDK",
            resources: [.process("Resources/PrivacyInfo.xcprivacy")],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-enable-private-imports"])
            ]
        ),

    ]
)
