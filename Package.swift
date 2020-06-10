// swift-tools-version:5.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "novy",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
         .package(url: "https://github.com/elegantchaos/Files.git", from: "1.0.5"),
         .package(url: "https://github.com/elegantchaos/Expressions.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "novy",
            dependencies: ["Expressions", "Files"]),
        .testTarget(
            name: "novyTests",
            dependencies: ["novy"]),
    ]
)
