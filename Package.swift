// swift-tools-version:5.6

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
    
    products: [
        .executable(name: "novy", targets: ["novy"])
    ],
    
    dependencies: [
         .package(url: "https://github.com/elegantchaos/CommandShell.git", from: "2.1.2"),
         .package(url: "https://github.com/elegantchaos/Expressions.git", from: "1.1.1"),
         .package(url: "https://github.com/elegantchaos/Files.git", from: "1.1.3"),
         .package(url: "https://github.com/elegantchaos/Runner.git", from: "1.3.0"),
         
         // tools
         .package(url: "https://github.com/elegantchaos/ActionBuilderPlugin.git", from: "1.0.7"),
         .package(url: "https://github.com/elegantchaos/SwiftFormatterPlugin.git", from: "1.0.3"),
    ],
    
    targets: [
        .executableTarget(
            name: "novy",
            dependencies: [
                .product(name: "CommandShell", package: "CommandShell"),
                .product(name: "Expressions", package: "Expressions"),
                .product(name: "Files", package: "Files"),
                .product(name: "FilesKit", package: "Files"),
                .product(name: "Runner", package: "Runner"),
        ]
        ),
        
        .testTarget(
            name: "novyTests",
            dependencies: ["novy"]
        ),
    ]
)
