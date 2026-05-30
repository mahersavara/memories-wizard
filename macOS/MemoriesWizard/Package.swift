// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "MemoriesWizard",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "MemoriesWizard",
            resources: [
                .process("../../Resources"),
                .process("../../Assets.xcassets")
            ]
        )
    ]
)
