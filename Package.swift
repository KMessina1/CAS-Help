// swift-tools-version: 6.2
/*-------------------------------------------------------------------------------------------------------------------------
     File: Package.swift
   Author: Kevin Messina
  Created: 8/22/26
 Modified: 08/22/2026 04:58 PM EDT
  Version: 1
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import PackageDescription

let package = Package(
    name: "CAS-Help",
    platforms: [
        .iOS(.v26),
        .macCatalyst(.v26)
    ],
    products: [
        .library(
            name: "CASHelp",
            targets: ["CASHelp"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/KMessina1/CAS-External-Foundations.git",
            from: "1.1.5"
        ),
        .package(
            url: "https://github.com/KMessina1/CAS-ThemeSupport.git",
            from: "1.1.1"
        ),
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            from: "6.29.3"
        )
    ],
    targets: [
        .target(
            name: "CASHelp",
            dependencies: [
                .product(
                    name: "CASExternalFoundations",
                    package: "CAS-External-Foundations"
                ),
                .product(
                    name: "CASThemeSupport",
                    package: "CAS-ThemeSupport"
                ),
                .product(
                    name: "GRDB",
                    package: "GRDB.swift"
                )
            ]
        ),
        .testTarget(
            name: "CASHelpTests",
            dependencies: ["CASHelp"]
        )
    ],
    swiftLanguageModes: [.v5]
)
