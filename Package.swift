// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Blueprints",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9),
        .macOS(.v10_11)
    ],
    products: [
        .library(name: "Blueprints", targets: ["Blueprints"]),
        .library(name: "BlueprintsMac", targets: ["BlueprintsMac"])
    ],
    targets: [
         .target(
            name: "Blueprints",
            path: "Sources",
            sources: [
                "Sources/Shared",
                "Sources/iOS+tvOS"
            ]
         ),
         .target(
            name: "BlueprintsMac",
            path: "Sources",
            sources: [
                "Sources/Shared",
                "Sources/macOS"
            ]
         )
    ]
)
